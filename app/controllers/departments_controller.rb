class DepartmentsController < ApplicationController
  before_action :load_department, only: %i(show edit update destroy)

  def new
    @department = Department.new
  end

  def create
    @department = Department.new department_params
    if @department.save
      flash[:success] = t "departments.new.created_successfully"
      redirect_to @department
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    departments = Department.search_by_name(params[:query]).order_by_latest
    @pagy, @departments = pagy departments, limit: Settings.ITEMS_PER_PAGE_10
  end

  def show; end

  def edit; end

  def update
    if @department.update department_params
      flash[:success] = t "departments.edit.updated_successfully"
      redirect_to @department
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @department.destroy
      flash[:success] = t "departments.destroy.success"
    else
      flash[:danger] = t "department.destroy.fail"
    end

    redirect_to departments_url, status: :see_other
  end

  private

  def department_params
    params.require(:department).permit Department::DEPARTMENT_PARAMS
  end

  def load_department
    @department = Department.find params[:id]
  end
end
