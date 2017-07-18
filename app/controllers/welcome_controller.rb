class WelcomeController < ApplicationController
	def index
		if @current_user
			render 'index.html.erb'
		else
			render 'welcome.html.erb'
		end
	end
