require "tempfile"

# Transcribes an attached audio file to text using Groq's Whisper endpoint.
#
#   AudioTranscriber.new(voice_memo.audio).call # => "2000 yen for lunch"
class AudioTranscriber
  MODEL = "whisper-large-v3-turbo".freeze
  DEFAULT_EXTENSION = ".webm".freeze

  def initialize(attachment, client: GroqClient.build)
    @attachment = attachment
    @client = client
  end

  def call
    @attachment.blob.open do |blob_file|
      Tempfile.create([ "voice_memo", extension ]) do |tmp|
        tmp.binmode
        IO.copy_stream(blob_file, tmp)
        tmp.rewind

        response = @client.audio.transcribe(
          parameters: { model: MODEL, file: tmp, language: language }
        )
        response["text"].to_s.strip
      end
    end
  end

  private

  def language
    locale = I18n.locale
    I18n.available_locales.include?(locale) ? locale.to_s : I18n.default_locale.to_s
  end

  def extension
    ext = @attachment.blob.filename.extension_with_delimiter
    ext.presence || DEFAULT_EXTENSION
  end
end
