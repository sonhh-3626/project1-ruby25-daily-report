class Manager::DepartmentsController < ApplicationController
  load_and_authorize_resource class: Department.name
  before_action :manager_user
  before_action :filter_users, only: :show

  def show
    @department = current_user.department
    @active_users_count = @department.users.active
                                     .not_manager
                                     .count
    @pagy, @users = pagy @users, limit: Settings.ITEMS_PER_PAGE_5
  end

  private

  def filter_users
    @users = User.managed_by(current_user)
                 .filter_by_active_status(active_status_param)
                 .filter_by_email params[:email]
  end

  def active_status_param
    params[:active_status].presence ||
      Settings.active_status[1]
  end
end
