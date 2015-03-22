# DepartmentsController
class DepartmentsController < ApplicationController
  authorize_resource :department

  def index
    search = Department.order { name }.search(params[:q])
    @departments = search.result
  end
end
