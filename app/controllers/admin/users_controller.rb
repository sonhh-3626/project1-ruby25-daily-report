class Admin::UsersController < ApplicationController
  load_and_authorize_resource class: User
  before_action :admin_user
  before_action :filter_users, only: :index

  def new
    @generated_password = SecureRandom.alphanumeric Settings.RANDOM_PW_LENGTH
    @user = User.new password: @generated_password
    @departments = Department.all
  end

  def create
    @user = User.new user_params_with_password
    if @user.save
      @user.department&.update(manager_id: @user.id) if @user.manager?
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
    old_department_id = @user.department_id
    old_role = @user.role

    if @user.update user_params
      update_department_manager(old_department_id, old_role)
      flash[:success] = t("users.edit.updated_successfully")
      redirect_to admin_users_path
    else
      @departments = Department.all
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

  def filter_users
    @users = User.not_admin
                 .filter_by_email(params[:email])
                 .filter_by_role(params[:role])
                 .filter_by_department params[:department_id]
  end

  def update_department_manager old_department_id, old_role
    remove_old_manager old_department_id, old_role
    assign_new_manager
  end

  def remove_old_manager old_department_id, old_role
    return unless old_role == Settings.ROLE_MANAGER &&
                  old_department_id.present? &&
                  (old_department_id != @user.department_id || @user.user?)

    Department.find_by(id: old_department_id)&.update(manager_id: nil)
  end

  def assign_new_manager
    return unless @user.manager? && @user.department_id.present?

    @user.department&.update(manager_id: @user.id)
  end
end
