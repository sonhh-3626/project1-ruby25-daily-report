class SessionsController < Devise::SessionsController
  layout "authentication"
  before_action :check_user_active, only: :create

  # rubocop:disable Lint/UselessMethodDefinition
  def create
    super
  end
  # rubocop:enable Lint/UselessMethodDefinition

  private

  def check_user_active
    @user = User.find_by email: params.dig(:user, :email)
    return if @user&.active?

    flash[:warning] = t "session.login.inactive_account"
    redirect_to new_user_session_path
  end
end
