class UsersController < ApplicationController

	before_action :authenticate

	def index
		users = User.all 
		@users = users.map(&:nest_data)
	end

	def show
		user = User.find(param[:id])
		@user = user.nest_data
	end

	private

		def authenticate
			if !current_user
				redirect_to root_path
			end
		end

end