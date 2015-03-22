class Admin::UsersController < ApplicationController
  authorize_resource

  before_filter lambda { @roles = %w'admin contact_admin contact_user' }, only: [:edit, :update]

  def edit
    @user = User.find(params[:id])
  end

  def index
    @users = User.order(:name).all
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.assign_attributes(user_params)
    @user.roles = (params[:role_names] || []).join(',')
    if @user.save
      redirect_to(admin_users_url(), notice: 'User was updated successfully.')
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:is_active, :roles)
  end
end
