require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get expenses_url(month: Date.current.strftime("%Y-%m"))
    assert_response :success
  end

  test "should get new" do
    get new_expense_url
    assert_response :success
  end

  test "new subscribes to the voice memo stream and renders in-progress memos" do
    memo = @user.voice_memos.create!(status: :processing, audio: audio_upload)

    get new_expense_url
    assert_response :success
    assert_select "turbo-cable-stream-source"
    assert_select "##{ActionView::RecordIdentifier.dom_id(memo)}",
                  text: /#{Regexp.escape(I18n.t("voice_memos.status.processing"))}/
  end

  test "CTAs are present" do
    get new_expense_url
    assert_select "a.btn", text: "Scan receipt"
    assert_select "button.btn", text: /Voice Input/
  end

  test "CTAs are present in Japanese" do
    get new_expense_url, headers: { "HTTP_ACCEPT_LANGUAGE" => "ja-JP" }
    assert_select "a.btn", text: "レシートをスキャン"
    assert_select "button.btn", text: /音声入力/
  end

  test "should get edit for an owned expense" do
    get edit_expense_url(expenses(:one))
    assert_response :success
    assert_select "form"
    assert_select "input[name=?]", "expense[amount]"
  end

  test "cannot edit another user's expense" do
    get edit_expense_url(expenses(:two))
    assert_redirected_to root_path
  end

  test "updates an owned expense and redirects to its month" do
    expense = expenses(:one)

    patch expense_url(expense), params: { expense: { amount: 9999, description: "Sushi dinner" } }

    assert_redirected_to expenses_path(month: expense.reload.spent_at.strftime("%Y-%m"))
    assert_equal BigDecimal("9999"), expense.amount
    assert_equal "Sushi dinner", expense.description
  end

  test "cannot update another user's expense" do
    expense = expenses(:two)
    original_amount = expense.amount

    patch expense_url(expense), params: { expense: { amount: 1 } }

    assert_redirected_to root_path
    assert_equal original_amount, expense.reload.amount
  end

  test "should redirect unauthenticated user to login view" do
    sign_out
    get expenses_path
    assert_redirected_to new_session_path
  end

  private

  def audio_upload
    {
      io: file_fixture("sample_audio.webm").open,
      filename: "sample_audio.webm",
      content_type: "audio/webm"
    }
  end
end
