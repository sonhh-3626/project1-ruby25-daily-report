class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  before_action :set_locale

  private
  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    unlogged_in_notification unless logged_in?
  end

  def unlogged_in_notification
    store_location
    flash[:danger] = t "users.errors.unlogged_in"
    redirect_to login_url, status: :see_other
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "users.errors.be_admin"
    redirect_to root_url, status: :see_other
  end

  def manager_user
    return if current_user.manager?

    flash[:danger] = t "users.errors.be_manager"
    redirect_to root_url, status: :see_other
  end

  def check_user_role
    return if current_user&.user?

    flash[:danger] = t "users.errors.be_user"
    redirect_to root_url, status: :see_other
  end
end
