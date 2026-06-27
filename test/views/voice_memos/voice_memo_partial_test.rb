require "test_helper"

class VoiceMemoPartialTest < ActionView::TestCase
  include IconHelper

  test "completed memo shows the amount, category and an edit CTA for its expense" do
    expense = expenses(:one)
    memo = users(:one).voice_memos.create!(status: :completed, expense: expense, audio: audio_blob)

    render partial: "voice_memos/voice_memo", locals: { voice_memo: memo }

    assert_select "div.alert-success"
    assert_select "a[href=?]", edit_expense_path(expense), text: I18n.t("voice_memos.status.edit")
  end

  test "in-progress memo shows a spinner and no edit CTA" do
    memo = users(:one).voice_memos.create!(status: :processing, audio: audio_blob)

    render partial: "voice_memos/voice_memo", locals: { voice_memo: memo }

    assert_select "span.loading-spinner"
    assert_select "a", false
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
