class SessionsController < ApplicationController
  before_action :ensure_params_exist, only: [:create], except: :destroy

  def new
  end

  def create
    @admin = Admin.where(email: admin_params[:email]).first
    return invalid_login_attempt unless @admin
    return invalid_login_attempt unless @admin.authenticate(admin_params[:password])
    reset_session
    session[:admin_id] = @admin.id.to_s
    redirect_to "/users"
  end

  def auth
    user = User.from_omniauth(request.env["omniauth.auth"], session)
    reset_session
    session[:user_id] = user.id.to_s
    redirect_to root_path
  end

  def delete
    reset_session
    redirect_to root_path
  end

  private

  def admin_params
    params.require(:admin).permit(:email, :password)
  end

  def ensure_params_exist
    if admin_params[:email].blank? || admin_params[:password].blank?
       invalid_login_attempt
    end
  end

  def invalid_login_attempt
    render json: {error: "Access denied"}, status: 400
  end
end