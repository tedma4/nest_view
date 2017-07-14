class AdminController < ApplicationController
  before_action :set_admin, only: [:update, :show]
  
  def create
  end

  def update
    if @admin.update_attributes(admin_params.to_h)
      render html: @admin.build_admin_hash, status: :ok
    else
      render html: @admin.errors, status: :unprocessable_entity
    end
  end

  def show
    render html: @admin.build_admin_hash
  end

  private
  
  def admin_params
    params.require(:admin).permit(:name, :password, :email)
  end

  def set_admin
    @admin = @current_user
  end
end

