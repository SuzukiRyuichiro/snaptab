class ExpensesController < ApplicationController
  def index
    @expenses = policy_scope(Expense)
  end

  def new
    @expense = Expense.new
    authorize @expense
  end

  def create
  end
end
