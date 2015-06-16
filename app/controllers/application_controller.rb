class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :require_login

  def authorized?(id)
    if current_user and User.find_by_email(current_user.email).guild_id and User.find_by_email(current_user.email).guild_id == id then return true else return false end
  end  

  def authorized_full?(id)
    if current_user and User.find_by_email(current_user.email).guild_id and User.find_by_email(current_user.email).guild_id == id then return true else return false end
  end

  private
	def not_authenticated
	  redirect_to login_path, alert: "Please login first"
	end


end
