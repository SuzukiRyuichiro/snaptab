require "test_helper"

class ExpenseExtractorTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @today = Date.new(2026, 6, 26)
  end

  test "maps the LLM JSON into expense attributes" do
    client = fake_client(
      { amount: 2000, currency: "JPY", category_slug: "food",
        description: "Lunch", spent_at: "2026-06-25" }
    )

    attrs = ExpenseExtractor.new(user: @user, client: client, today: @today).call("2000 yen for lunch yesterday")

    assert_equal BigDecimal("2000"), attrs[:amount]
    assert_equal "JPY", attrs[:currency]
    assert_equal categories(:food), attrs[:category]
    assert_equal "Lunch", attrs[:description]
    assert_equal Date.new(2026, 6, 25), attrs[:spent_at]
  end

  test "falls back to misc category for an unknown slug" do
    client = fake_client({ amount: 500, category_slug: "spaceships" })

    attrs = ExpenseExtractor.new(user: @user, client: client, today: @today).call("500 yen")

    assert_equal categories(:misc), attrs[:category]
  end

  test "defaults spent_at to today when the date is missing" do
    client = fake_client({ amount: 500, category_slug: "food" })

    attrs = ExpenseExtractor.new(user: @user, client: client, today: @today).call("500 yen for food")

    assert_equal @today, attrs[:spent_at]
  end

  test "raises when no amount can be determined" do
    client = fake_client({ category_slug: "food" })

    assert_raises(ExpenseExtractor::ExtractionError) do
      ExpenseExtractor.new(user: @user, client: client, today: @today).call("hello there")
    end
  end

  private

  # Returns a stub client whose #chat replies with the given payload as JSON.
  def fake_client(payload)
    content = payload.to_json
    Class.new do
      define_method(:chat) do |parameters:|
        { "choices" => [ { "message" => { "content" => content } } ] }
      end
    end.new
  end
end
