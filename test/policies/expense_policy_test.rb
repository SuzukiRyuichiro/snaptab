require "test_helper"

class ExpensePolicyTest < ActiveSupport::TestCase
  def test_scope
    user1 = users(:one)
    user2 = users(:two)
    expense1 = expenses(:one)  # belongs to user1
    expense2 = expenses(:two)  # belongs to user2

    # Scope for user1 should only return user1's expenses
    scope = ExpensePolicy::Scope.new(user1, Expense.all)
    assert_equal [ expense1 ], scope.resolve.to_a

    # Scope for user2 should only return user2's expenses
    scope = ExpensePolicy::Scope.new(user2, Expense.all)
    assert_equal [ expense2 ], scope.resolve.to_a
  end

  def test_new
    assert_permit users(:one), Expense.new, :new
  end

  def test_create
    assert_permit users(:one), Expense.new, :create
  end

  def test_update
    # Only the owner can update an expense
    owner = users(:one)
    other_user = users(:two)
    expense = expenses(:one)  # belongs to owner

    assert_permit owner, expense, :update
    refute_permit other_user, expense, :update
  end

  def test_destroy
    # Only the owner can destroy an expense
    owner = users(:one)
    other_user = users(:two)
    expense = expenses(:one)  # belongs to owner

    assert_permit owner, expense, :destroy
    refute_permit other_user, expense, :destroy
  end
end
