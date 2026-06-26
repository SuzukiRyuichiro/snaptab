class PagesController < ApplicationController
  allow_unauthenticated_access only: [ :home ]
  before_action :set_no_dock, only: [ :home ]

  def home
    redirect_to new_expense_path if authenticated?
  end

  def settings
  end


end
