require "test_helper"

class VoiceMemoTest < ActiveSupport::TestCase
  setup { @user = users(:one) }

  test "defaults to pending status" do
    assert_equal "pending", VoiceMemo.new.status
  end

  test "is invalid without an attached audio" do
    memo = @user.voice_memos.new
    assert_not memo.valid?
    assert_includes memo.errors[:audio], "can't be blank"
  end

  test "is valid with an attached audio" do
    memo = @user.voice_memos.new
    memo.audio.attach(
      io: file_fixture("sample_audio.webm").open,
      filename: "sample_audio.webm",
      content_type: "audio/webm"
    )
    assert memo.valid?
  end

  test "in_progress includes only pending and processing memos" do
    pending = @user.voice_memos.create!(status: :pending, audio: audio_blob)
    processing = @user.voice_memos.create!(status: :processing, audio: audio_blob)
    failed = @user.voice_memos.create!(status: :failed, audio: audio_blob)
    completed = @user.voice_memos.create!(status: :completed, audio: audio_blob)

    result = @user.voice_memos.in_progress
    assert_includes result, pending
    assert_includes result, processing
    assert_not_includes result, failed
    assert_not_includes result, completed
  end

  private

  def audio_blob
    {
      io: file_fixture("sample_audio.webm").open,
      filename: "sample_audio.webm",
      content_type: "audio/webm"
    }
  end
end
