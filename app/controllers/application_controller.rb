class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def current_user
    session[:current_user]
  end

protected
  def authenticate_user!
    session[:return_to] ||= request.fullpath
    if current_user
      redirect_to session.delete(:return_to)
    else
      redirect_to sign_in_users_path
    end
  end
end
