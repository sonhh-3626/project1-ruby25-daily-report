class Manager::DepartmentsController < ApplicationController
  before_action :logged_in_user, :manager_user
  before_action :load_department, only: :show
  before_action :load_departments, :fitler_departments, only: :index

  def index
    @pagy, @departments = pagy @departments, items: Settings.ITEMS_PER_PAGE_10
  end

  def show; end

  private

  def load_department
    @department = Department.find_by id: params[:id]
    return if @department

    flash[:danger] = t "departments.errors.not_found"
    redirect_to manager_departments_path, status: :see_other
  end

  def load_departments
    @departments = current_user.managed_departments
    return if @departments.present?

    flash[:danger] = t "departments.errors.not_found"
  end

  def fitler_departments
    @departments = Department.search_by_name(params[:query])
                             .order_by_latest
    return if @departments.present?

    flash[:warning] = t "departments.index.table.no_result"
    redirect_to manager_departments_path, status: :see_other
  end

  def manager_user
    return if current_user.manager?

    flash[:danger] = t "users.error.not_manager"
    redirect_to root_url, status: :see_other
  end
end
