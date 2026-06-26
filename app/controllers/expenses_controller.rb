class ExpensesController < ApplicationController
  def index
    if params[:month].blank? || (params[:month] =~ /\A\d{4}-\d{2}\z/).nil?
      skip_policy_scope
      redirect_to expenses_path(month: Date.current.strftime("%Y-%m")) and return
    end

    from =
      if params[:month].present?
        begin
          Date.strptime(params[:month], "%Y-%m")
        rescue ArgumentError
          Date.current.beginning_of_month
        end
      else
        Date.current.beginning_of_month
      end
    to = from.end_of_month

    expense_and_category = policy_scope(Expense).joins(:category).where("spent_at between ? and ?", from, to)
    @total_expense = expense_and_category.pluck(:amount).sum
    @expenses_grouped_by_date = expense_and_category.order(spent_at: :desc).group_by(&:spent_at)
    @category_breakdown = expense_and_category.group("categories.slug").sum(:amount).sort_by { |k, v| -v }.to_h
    @localized_category_breakdown = @category_breakdown.transform_keys { |slug| I18n.t("categories.#{slug}") }

    @voice_memos = policy_scope(VoiceMemo).in_progress.order(created_at: :desc)

    # For the dropdown
    @months = policy_scope(Expense)
               .where.not(spent_at: nil)
               .order(spent_at: :desc)
               .pluck(:spent_at)
               .map { |date| date.strftime("%Y-%m") }
               .uniq
  end

  def new
    @expense = Expense.new
    authorize @expense
  end

  def create
  end
end
