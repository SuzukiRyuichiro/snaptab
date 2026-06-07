class ExpensesController < ApplicationController
  def index
    from = Date.strptime(params[:month], "%Y-%m")
    to = from.end_of_month
    expense_and_category = policy_scope(Expense).joins(:category).where("spent_at between ? and ?", from, to)
    @expenses = expense_and_category.order(spent_at: :desc)
    @category_breakdown = expense_and_category.group("categories.display_name, categories.slug").sum(:amount)
    # Scope only the selected month
    # query params would have the selected month params[:month]=2026-06
    # if not, or the format is not good, use the current date, force it
    #
    # Group possible months
  end

  def new
    @expense = Expense.new
    authorize @expense
  end

  def create
  end
end
