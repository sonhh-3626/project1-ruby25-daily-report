class User::DailyReportsController < ApplicationController
  before_action :check_user_role
  before_action :set_daily_report, only: %i(show edit update destroy)
  before_action :filter_daily_reports, only: :index
  before_action :check_status, only: :edit

  def new
    @daily_report = current_user.sent_reports.build
  end

  def create
    @daily_report = current_user.sent_reports.build daily_report_params

    if @daily_report.save
      flash[:success] = t "daily_report.create.success"
      redirect_to user_daily_reports_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @pagy, @daily_reports = pagy(
      @daily_reports,
      limit: Settings.ITEMS_PER_PAGE_10
    )
  end

  def show; end

  def edit; end

  def update
    if @daily_report.update(daily_report_params)
      flash[:success] = t "daily_report.update.success"
      redirect_to [:user, @daily_report]
    else
      flash.now[:danger] = t "daily_report.update.failure"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @daily_report.status_pending?
      @daily_report.destroy
      flash[:success] = t "daily_report.delete.success"
    else
      flash[:danger] = t "daily_report.delete.forbidden_status"
    end

    redirect_to user_daily_reports_path, status: :see_other
  end

  private

  def daily_report_params
    params.require(:daily_report).permit DailyReport::DAILY_REPORT_PARAMS
  end

  def set_daily_report
    @daily_report = DailyReport.find_by id: params[:id]
    return if @daily_report

    flash[:danger] = t "set_daily_report.errors.not_found"
    redirect_to user_daily_reports_path, status: :see_other
  end

  def filter_daily_reports
    @daily_reports = current_user.sent_reports
                                 .by_status(params[:status])
                                 .by_report_date(params[:report_date])
                                 .order_created_at_desc
  end

  def check_status
    return unless @daily_report.status_read?

    flash[:danger] = t "daily_report.edit.forbidden_status"
    redirect_to user_daily_reports_path, status: :see_other
  end
end
