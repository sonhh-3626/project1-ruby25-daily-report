class Admin::DashboardController < ApplicationController
  before_action :admin_user

  def show
    @departments_count = Department.count
    @managers_count = User.manager_count
    @users_count = User.user_count
  end
end
