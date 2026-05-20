require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(User.first)
  end

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
    get new_expense_url, headers: { "HTTP_ACCEPT_LANGUAGE" => 'ja-JP' }
    assert_select "a.btn", text: "レシートをスキャン"
    assert_select "button.btn", text: /音声入力/
  end

  test "should redirect unauthenticated user to login view" do
    sign_out
    get expenses_path
    assert_redirected_to new_session_path
  end
end
