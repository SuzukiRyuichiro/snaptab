require "test_helper"

class AudioTranscriberTest < ActiveSupport::TestCase
  test "returns the transcript text from the Whisper response" do
    memo = users(:one).voice_memos.create!(
      audio: {
        io: file_fixture("sample_audio.webm").open,
        filename: "sample_audio.webm",
        content_type: "audio/webm"
      }
    )

    client = fake_client("2000 yen for lunch")

    assert_equal "2000 yen for lunch", AudioTranscriber.new(memo.audio, client: client).call
  end

  private

  # Stub client exposing #audio.transcribe like ruby-openai does.
  def fake_client(text)
    audio = Class.new do
      define_method(:transcribe) { |parameters:| { "text" => text } }
    end.new

    Class.new do
      define_method(:audio) { audio }
    end.new
  end
end
