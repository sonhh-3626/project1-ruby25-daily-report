class Manager::DashboardController < ApplicationController
  before_action :manager_user

  def show
    @department = current_user.department
    @active_users_count = @department.users.active
                                     .not_manager
                                     .count
    @pending_reports_count = DailyReport.count_by_status_pending current_user
  end
end
