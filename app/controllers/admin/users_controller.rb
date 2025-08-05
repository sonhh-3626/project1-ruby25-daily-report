class Admin::UsersController < ApplicationController
  before_action :logged_in_user, :admin_user
  before_action :filter_users, only: :index
  before_action :find_user, only: %i(edit update)

  def index
    @pagy, @users = pagy @users, limit: Settings.ITEMS_PER_PAGE_10
  end

  def edit
    @departments = Department.all
  end

  def update
    if @user.update user_params
      flash[:success] = t "users.edit.updated_successfully"
      redirect_to admin_users_path
    else
      flash[:danger] = t "users.errors.not_found"
      render :edit
    end
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
    @users = User.filter_by_email(params[:email])
                 .filter_by_role(params[:role])
                 .filter_by_department params[:department_id]
    return if @users.present?

    flash[:warning] = t "users.index.table.no_result"
    redirect_to admin_users_path, status: :see_other
  end
end
