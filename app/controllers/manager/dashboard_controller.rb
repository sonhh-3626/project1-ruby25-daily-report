class Manager::DashboardController < ApplicationController
  def show
    @department = current_user.department
    @staff_count = @department.users.where(role: :user).count
    @pending_reports_count = DailyReport.where(receiver: current_user, status: :pending).count
  end
end
