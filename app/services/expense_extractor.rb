require "json"
require "bigdecimal"

# Turns a free-form transcript into structured Expense attributes using Groq's
# LLM (JSON mode). Handles bilingual (EN/JA) speech and relative dates.
#
#   ExpenseExtractor.new(user: user).call("2000 yen for lunch")
#   # => { amount: 2000, currency: "JPY", category: #<Category food>,
#   #      description: "Lunch", spent_at: Date.current }
class ExpenseExtractor
  MODEL = "llama-3.1-8b-instant".freeze

  class ExtractionError < StandardError; end

  def initialize(user:, client: GroqClient.build, today: Date.current)
    @user = user
    @client = client
    @today = today
  end

  def call(transcript)
    raise ExtractionError, "Empty transcript" if transcript.blank?

    data = request_json(transcript)

    amount = parse_amount(data["amount"])
    raise ExtractionError, "Could not determine an amount from: #{transcript.inspect}" if amount.nil?

    {
      amount: amount,
      currency: data["currency"].presence || @user.currency,
      category: resolve_category(data["category_slug"]),
      description: data["description"].presence || transcript.truncate(255),
      spent_at: parse_date(data["spent_at"])
    }
  end

  private

  def request_json(transcript)
    response = @client.chat(parameters: {
      model: MODEL,
      temperature: 0,
      response_format: { type: "json_object" },
      messages: [
        { role: "system", content: system_prompt },
        { role: "user", content: transcript }
      ]
    })
    content = response.dig("choices", 0, "message", "content")
    JSON.parse(content.to_s)
  rescue JSON::ParserError => e
    raise ExtractionError, "LLM returned invalid JSON: #{e.message}"
  end

  def system_prompt
    <<~PROMPT
      You extract a single expense from a short spoken sentence. The speaker may use
      English or Japanese. Reply with ONLY a JSON object, no prose.

      Fields:
      - "amount": number, the expense amount with no currency symbol or separators (e.g. 2000).
      - "currency": ISO code, one of #{currency_codes.join(", ")}. Infer from words like
        "yen"/"円" (JPY) or "dollars"/"$" (USD). Use #{default_currency.inspect} if unclear.
      - "category_slug": one of #{Category::SLUGS.join(", ")}. Pick the best fit;
        use "#{Category::FALLBACK_SLUG}" if nothing fits.
      - "description": a short human label for the expense, written in #{locale_name}.
      - "spent_at": ISO date (YYYY-MM-DD). Today is #{@today.iso8601}. Resolve relative
        dates like "yesterday"/"昨日". Use today if no date is mentioned.

      Example: input "昨日ランチに2000円" =>
      {"amount":2000,"currency":"JPY","category_slug":"food","description":"ランチ","spent_at":"#{(@today - 1).iso8601}"}
    PROMPT
  end

  def currency_codes
    %w[JPY USD]
  end

  def default_currency
    @user.currency.presence || "JPY"
  end

  def locale_name
    @user.locale == :ja ? "Japanese" : "English"
  end

  def resolve_category(slug)
    Category.find_by(slug: slug) || Category.find_by(slug: Category::FALLBACK_SLUG) ||
      raise(ExtractionError, "No category available (is the database seeded?)")
  end

  def parse_amount(raw)
    return nil if raw.nil?

    value = BigDecimal(raw.to_s)
    value.positive? ? value : nil
  rescue ArgumentError
    nil
  end

  def parse_date(raw)
    Date.iso8601(raw.to_s)
  rescue ArgumentError, TypeError
    @today
  end
end
