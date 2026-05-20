class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Pundit
  after_action :verify_pundit_authorization, unless: :skip_pundit?

  def verify_pundit_authorization
    if action_name == "index"
      verify_policy_scoped
    else
      verify_authorized
    end
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    Current.user
  end

  # i18n
  around_action :switch_locale

  def switch_locale(&action)
    locale = extract_locale_from_accept_language_header
    I18n.with_locale(locale, &action)
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back_or_to(root_path)
  end

  def skip_pundit?
    controller_name == "pages" || controller_name == "sessions" || controller_name == "passwords"
  end

  def extract_locale_from_accept_language_header
    return Current.user.locale if authenticated? && Current.user.locale.present?

    if request.env["HTTP_ACCEPT_LANGUAGE"].present?
      request_locale = request.env["HTTP_ACCEPT_LANGUAGE"].scan(/^[a-z]{2}/).first.to_sym
      return request_locale if I18n.available_locales.include?(request_locale)
    end

    I18n.default_locale
  end

  def set_no_dock
    @no_dock = true
  end
end
