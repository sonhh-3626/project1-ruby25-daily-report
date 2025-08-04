class SessionsController < ApplicationController
  layout "authentication", only: %i(new create)
  before_action :find_user_by_email, only: :create

  def new; end

  def create
    if @user&.authenticate params.dig(:session, :password)
      handle_authenticated_user
    else
      handle_invalid_login
    end
  end

  def destroy
    log_out if logged_in?
    forget current_user if current_user

    redirect_to login_path, status: :see_other
  end

  private

  def find_user_by_email
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return if @user

    flash.now[:danger] = t "users.errors.invalid_email"
    render :new, status: :unprocessable_entity
  end

  def handle_remember_me_for user
    if params.dig(:session, :remember_me) == Settings.REMEMBER_ME_ENABLED
      remember user
    else
      forget user
    end
  end

  def handle_authenticated_user
    reset_session
    handle_remember_me_for @user
    log_in @user
    redirect_to root_path
    flash[:success] = t "session.login.success"
  end

  def handle_invalid_login
    flash.now[:danger] = t "session.login.invalid"
    render :new, status: :unprocessable_entity
  end
end
