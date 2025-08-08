class Admin::UsersController < ApplicationController
  before_action :logged_in_user, :admin_user
  before_action :filter_users, only: :index
  before_action :find_user, only: %i(edit update show destroy)

  def new
    @generated_password = SecureRandom.alphanumeric Settings.RANDOM_PW_LENGTH
    @user = User.new password: @generated_password
    @departments = Department.all
  end

  def create
    @user = User.new user_params_with_password
    if @user.save
      @generated_password = params.dig :user, :password
      UserMailer.welcome_email(@user, @generated_password).deliver_now
      flash[:success] = t "users.create.success"
      redirect_to admin_users_path
    else
      @generated_password = SecureRandom.alphanumeric Settings.RANDOM_PW_LENGTH
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

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
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.update active: false
      flash[:success] = t "users.unactive.success"
      redirect_to admin_users_path, status: :see_other
    else
      flash.now[:danger] = t "users.unactive.fail"
    end
  end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def user_params_with_password
    params.require(:user).permit User::USER_PARAMS_WITH_PW
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.errors.not_found"
    redirect_to admin_users_path, status: :see_other
  end

  def filter_users
    @users = User.not_admin
                 .filter_by_email(params[:email])
                 .filter_by_role(params[:role])
                 .filter_by_department params[:department_id]
  end
end
