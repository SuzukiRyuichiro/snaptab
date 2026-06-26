require "test_helper"

class VoiceMemosControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "creates a voice memo, enqueues transcription, and redirects" do
    assert_difference -> { VoiceMemo.count }, 1 do
      assert_enqueued_with(job: TranscribeVoiceMemoJob) do
        post voice_memos_url, params: { audio: audio_upload }
      end
    end

    assert_redirected_to expenses_path
    assert VoiceMemo.last.audio.attached?
  end

  test "redirects unauthenticated users to login" do
    sign_out
    assert_no_difference -> { VoiceMemo.count } do
      post voice_memos_url, params: { audio: audio_upload }
    end
    assert_redirected_to new_session_path
  end

  private

  def audio_upload
    fixture_file_upload("sample_audio.webm", "audio/webm")
  end
end
