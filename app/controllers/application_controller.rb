class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :validate

  def current_user
  	session[:user_id] = nil
  	type = session[:admin_id].blank? ? (!session[:user_id].blank? ? User : nil) : Admin
  	return false unless type
  	id = type.to_s.downcase + "_id"
    @current_user ||= type.find(session[id.to_sym])
  end

	def validate
		if !current_user
			redirect_to root_path
		end
	end
end
