module Configuration
  class DepartmentsController < ApplicationController
    authorize_resource :department

    before_action :find_department, :only => [:edit, :show, :update]
    before_action :load_companies, :only => [:create, :edit, :new, :update]

    def create
      @department = Department.new(department_params)

      if @department.save
        redirect_to(configuration_department_path(@department.id),
                    :notice => t('app.department.create.success'))
      else
        render :new
      end
    end

    def edit; end

    def index
      @departments = Department.order { name }.to_a
    end

    def new
      @department = Department.new
    end

    def show; end

    def update
      if @department.update_attributes(department_params)
        redirect_to(configuration_department_path(@department.id),
                    :notice => t('app.department.update.success'))
      else
        render :edit
      end
    end

    protected

    def department_params
      params.require(:department).permit(:company_id, :name)
    rescue ActionController::ParameterMissing; {}
    end

    def find_department
      @department = Department.find(params[:id])
    end

    def load_companies
      @companies = Company.order { name }.to_a
    end
  end
end
