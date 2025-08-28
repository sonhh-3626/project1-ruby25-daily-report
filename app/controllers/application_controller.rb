class ApplicationController < ActionController::Base
  include Pagy::Backend
  include NavigationHelper

  before_action :set_locale
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do
    handle_access_denied
  end

  rescue_from ActiveRecord::RecordNotFound do
    handle_record_not_found
  end

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

  def handle_access_denied
    flash[:warning] = t "users.errors.no_right"
    redirect_to root_url, status: :see_other
  end

  def handle_record_not_found
    record_name = controller_name.singularize.humanize
    flash[:warning] = t("common.record_not_found", record_name:)
    redirect_to root_url, status: :see_other
  end

  def authorize_role role
    return if current_user.send("#{role}?")

    handle_access_denied
  end

  def admin_user
    authorize_role :admin
  end

  def manager_user
    authorize_role :manager
  end

  def check_user_role
    authorize_role :user
  end

  def after_sign_in_path_for resource
    send("#{resource.role}_dashboard_show_path")
  end
end
