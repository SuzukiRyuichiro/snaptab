# Builds an OpenAI-compatible client pointed at Groq.
#
# Groq exposes an OpenAI-compatible API, so the ruby-openai gem works against it
# for both Whisper transcription and chat completions. Swapping providers (e.g. to
# OpenAI proper) is just a matter of changing the api key + uri_base here.
class GroqClient
  URI_BASE = "https://api.groq.com/openai/v1".freeze

  def self.build
    OpenAI::Client.new(
      access_token: api_key,
      uri_base: URI_BASE,
      request_timeout: 60
    )
  end

  def self.api_key
    Rails.application.credentials.groq_api_key || ENV["GROQ_API_KEY"] ||
      raise("Missing Groq API key. Set credentials.groq_api_key or GROQ_API_KEY.")
  end
end
