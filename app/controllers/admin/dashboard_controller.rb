class Admin::DashboardController < ApplicationController
  before_action :logged_in_user, :admin_user

  def show
    @departments_count = Department.count
    @managers_count = User.where(role: :manager).count
    @users_count = User.where(role: :user).count
  end
end
