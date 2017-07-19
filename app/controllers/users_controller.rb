class UsersController < ApplicationController

	before_action :validate, except: [:create]

	def new
		@user = User.new
	end


	def create
		@user = User.new(user_params)
		if @user.valid?
		reset_session
			user = @user.build_user_hash
			user[:password] = user_params[:password]
			session[:user] = user
			redirect_to "/auth/nest"
		else
			reset_session
			redirect_to "/"
		end
	end

	def index
		users = User.all 
		@users = users.map(&:nest_data)
	end

	def show
		user = User.find(params[:id])
		@user = user.nest_data
	end

	private

		def user_params
			params.require(:user).permit(:name, :email, :password)
		end
end