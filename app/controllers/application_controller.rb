class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

protected
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
  helper_method :current_user

  def authenticate_user!
    if current_user.nil?
      session[:return_to] ||= request.fullpath
      redirect_to sign_in_users_path
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
