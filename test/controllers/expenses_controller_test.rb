require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get expenses_url
    assert_response :success
  end

  test "should get new" do
    get new_expense_url
    assert_response :success
  end

  test "CTAs are present" do
    get new_expense_url
    assert_select 'a.btn', text: "Scan receipt"
    assert_select 'button.btn', text: /Voice Input/
  end

  test "CTAs are present in Japanese" do
    I18n.with_locale(:ja) do
      get new_expense_url
      assert_select 'a.btn', text: "レシートをスキャン"
      assert_select 'button.btn', text: /音声入力/
    end
  end
end
