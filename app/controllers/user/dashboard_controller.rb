class User::DashboardController < ApplicationController
  before_action :check_user_role

  def show
    @daily_reports = current_user.sent_reports.in_month Date.current
  end
end
