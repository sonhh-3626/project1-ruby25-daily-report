class Manager::UsersController < ApplicationController
  before_action :manager_user
  before_action :find_user, only: %i(show destroy)
  before_action :get_unassigned_users, only: %i(new create)

  def new; end

  def create
    user = @available_users.find_by id: params[:user_id]
    department = current_user.department
    if user && department
      user.update(department:)
      flash[:success] = t "users.assign.success"
      redirect_to manager_department_path(current_user.department)
    else
      flash[:danger] = t "users.assign.fail"
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
    redirect_to manager_department_path(current_user.department)
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

  def get_unassigned_users
    @available_users = User.unassigned_users
    return if @available_users.present?

    flash[:warning] = t "users.new.no_user_for_assign"
    redirect_to manager_department_path(current_user.department)
  end
end
