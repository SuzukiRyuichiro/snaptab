class ExpensesController < ApplicationController
  def index
    @expenses = Current.user.expenses
  end

  def new
    @expense = Expense.new
  end

  def create
  end
end
