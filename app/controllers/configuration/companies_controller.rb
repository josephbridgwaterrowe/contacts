module Configuration
  class CompaniesController < ApplicationController
    authorize_resource :company

    before_action :find_company, :only => [:edit, :show, :update]

    def create
      @company = Company.new(company_params)

      if @company.save
        redirect_to(configuration_company_path(@company.id),
                    :notice => t('contacts.company.create.success'))
      else
        render :new
      end
    end

    def edit; end

    def index
      @companies = Company.order { name }.to_a
    end

    def new
      @company = Company.new
    end

    def show; end

    def update
      if @company.update_attributes(company_params)
        redirect_to(configuration_company_path(@company.id),
                    :notice => t('contacts.company.update.success'))
      else
        render :edit
      end
    end

    protected

    def company_params
      params.require(:company).permit(:name)
    rescue ActionController::ParameterMissing; {}
    end

    def find_company
      @company = Company.find(params[:id])
    end
  end
end
