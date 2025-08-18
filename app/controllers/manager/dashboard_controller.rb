class Manager::DashboardController < ApplicationController
  before_action :logged_in_user, :manager_user

  def show
    @department = current_user.department
    @staff_count = @department.users.user_count
    @pending_reports_count = DailyReport.count_by_status_pending current_user
  end
end
