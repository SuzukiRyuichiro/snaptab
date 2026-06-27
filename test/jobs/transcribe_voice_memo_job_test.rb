require "test_helper"

class TranscribeVoiceMemoJobTest < ActiveJob::TestCase
  setup do
    @memo = users(:one).voice_memos.create!(
      audio: {
        io: file_fixture("sample_audio.webm").open,
        filename: "sample_audio.webm",
        content_type: "audio/webm"
      }
    )
  end

  test "creates an expense, completes the memo, and purges the audio" do
    transcriber = double_returning("2000 yen for lunch")
    extractor = double_returning(
      amount: 2000, currency: "JPY", category: categories(:food),
      description: "Lunch", spent_at: Date.new(2026, 6, 26)
    )

    assert_difference -> { Expense.count }, 1 do
      stub_new(AudioTranscriber, transcriber) do
        stub_new(ExpenseExtractor, extractor) do
          TranscribeVoiceMemoJob.perform_now(@memo.id)
        end
      end
    end

    @memo.reload
    assert @memo.completed?
    assert_equal "2000 yen for lunch", @memo.transcript
    assert_not_nil @memo.expense
    assert_not @memo.audio.attached?
    assert_equal BigDecimal("2000"), @memo.expense.amount
  end

  test "marks the memo failed and re-raises when transcription errors" do
    boom = Object.new
    def boom.call(*) = raise("transcription failed")

    assert_no_difference -> { Expense.count } do
      assert_raises(RuntimeError) do
        stub_new(AudioTranscriber, boom) do
          TranscribeVoiceMemoJob.perform_now(@memo.id)
        end
      end
    end

    @memo.reload
    assert @memo.failed?
    assert_equal "transcription failed", @memo.error_message
  end

  private

  # A test double whose #call (with any args) returns the given value.
  def double_returning(value)
    obj = Object.new
    obj.define_singleton_method(:call) { |*| value }
    obj
  end

  # Temporarily makes klass.new return the given instance.
  def stub_new(klass, instance)
    original = klass.method(:new)
    klass.define_singleton_method(:new) { |*, **| instance }
    yield
  ensure
    klass.singleton_class.send(:define_method, :new, original)
  end
end
