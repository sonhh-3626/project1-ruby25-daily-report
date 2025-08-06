class Manager::DailyReportsController < ApplicationController
<<<<<<< HEAD
  before_action :logged_in_user, :manager_user
=======
>>>>>>> 4a99617 ([Manager] Quản lý danh sách báo cáo công việc của nhân viên)
  before_action :set_daily_report, only: %i(edit update)
  before_action :set_staff_members, :filter_daily_reports, only: :index

  def index
    @pagy, @daily_reports = pagy(
      @daily_reports.includes(:owner).order_created_at_desc,
      items: Settings.ITEMS_PER_PAGE_10
    )
  end

  def edit; end

  def update
<<<<<<< HEAD
    if @daily_report.update daily_report_params
=======
    new_notes = daily_report_params[:manager_notes]&.strip
    old_notes = @daily_report.manager_notes&.strip

    if @daily_report.update daily_report_params
      update_status new_notes, old_notes
>>>>>>> 4a99617 ([Manager] Quản lý danh sách báo cáo công việc của nhân viên)
      flash[:success] = t "daily_report.update.success"
      redirect_to manager_daily_reports_path, status: :see_other
    else
      flash.now[:alert] = t "daily_report.update.failure"
      render :edit
    end
  end

  private

  def daily_report_params
<<<<<<< HEAD
    dr_params = params.require(:daily_report)
                      .permit DailyReport::MANAGER_NOTE_PARAM
    new_notes = dr_params[:manager_notes]&.strip
    old_notes = @daily_report.manager_notes&.strip
    dr_params[:status] = update_status new_notes, old_notes
    dr_params[:reviewed_at] = Time.current if dr_params[:status] != :pending
    dr_params
=======
    params.require(:daily_report).permit DailyReport::MANAGER_NOTE_PARAM
>>>>>>> 4a99617 ([Manager] Quản lý danh sách báo cáo công việc của nhân viên)
  end

  def set_daily_report
    @daily_report = DailyReport.find_by id: params[:id]
    return if @daily_report

    flash[:alert] = t "daily_report.errors.not_found"
    redirect_to manager_daily_reports_path, status: :see_other
  end

  def set_staff_members
    @staff_members = User.get_staff_members(current_user)
  end

  def filter_daily_reports
    @daily_reports = DailyReport.by_owner_id(@staff_members.pluck(:id))
                                .filter_by_status(params[:status])
                                .filter_by_report_date(params[:report_date])
                                .filter_by_owner params[:user_id]
  end

  def update_status new_notes, old_notes
<<<<<<< HEAD
    if new_notes.present? && new_notes != old_notes
      :commented
    elsif new_notes.blank? && old_notes.present?
      :read
    elsif new_notes == old_notes
      :commented
    else
      :read
    end
=======
    new_status = if new_notes.present? && new_notes != old_notes
                   :commented
                 elsif new_notes.blank? && old_notes.present?
                   :read
                 elsif new_notes == old_notes
                   :commented
                 else
                   :read
                 end

    return if @daily_report.status == new_status.to_s

    @daily_report.update_column :status, new_status
>>>>>>> 4a99617 ([Manager] Quản lý danh sách báo cáo công việc của nhân viên)
  end
end
