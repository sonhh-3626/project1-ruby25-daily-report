class SessionsController < Devise::SessionsController
  layout "authentication"
  before_action :check_user_active, only: :create

  private

  def check_user_active
    @user = User.find_by email: params.dig(:user, :email)
    if @user && !@user.active?
      flash[:warning] = t "session.login.inactive_account"
      redirect_to new_user_session_path
    end
  end
end
