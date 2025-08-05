class Manager::UsersController < ApplicationController
  before_action :logged_in_user, :manager_user
  before_action :filter_users, only: :index
  before_action :find_user, only: %i(show destroy)
  before_action :get_unassigned_users, only: %i(new create)

  def index
    @pagy, @users = pagy @users, limit: Settings.ITEMS_PER_PAGE_10
  end

  def new; end

  def create
    user = @available_users.find_by id: params[:user_id]
    department = current_user.department
    if user && department
      user.update(department:)
      flash[:success] = t("users.assign.success")
      redirect_to manager_users_path
    else
      flash[:danger] = t("users.assign.fail")
      redirect_to new_manager_user_path
    end
  end

  def show; end

  def destroy
    if @user.update department_id: nil
      flash[:success] = t "users.success.deleted"
    else
      flash[:danger] = t "users.error.delete_failed"
    end
    redirect_to manager_users_url, status: :see_other
  end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.errors.not_found"
    redirect_to admin_users_path, status: :see_other
  end

  def filter_users
    @users = User.managed_by(current_user)
                 .filter_by_role(:user)
                 .filter_by_email(params[:email])
                 .filter_by_department params[:department_id]
    return if @users.present?

    flash[:warning] = t "users.index.table.no_result"
    redirect_to manager_users_path, status: :see_other
  end

  def get_unassigned_users
    @available_users = User.unassigned_users
    return if @available_users.present?

    flash[:warning] = t "users.new.no_user_for_assign"
    redirect_to manager_users_path, status: :see_other
  end
end
