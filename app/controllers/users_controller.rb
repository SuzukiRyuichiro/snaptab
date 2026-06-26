class UsersController < ApplicationController
  def update
    @user = Current.user
    authorize @user
    puts "locale"
    pp user_params
    @user.update!(user_params)
    redirect_to settings_path, notice: t("pages.settings.saved")
  end

  private

  def user_params
    params.require(:user).permit(:locale, :currency)
  end
end
