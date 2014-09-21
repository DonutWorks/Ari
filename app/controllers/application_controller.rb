class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def current_user
    User.find_by_id(session[:current_user])
  end

protected
  def authenticate_user!
    session[:return_to] ||= request.fullpath
    if current_user.nil?
      redirect_to sign_in_users_path
    end
  end

  def require_auth_hash
    if auth_hash.nil?
      redirect_to sign_in_users_path
    end
  end

  def auth_hash
    session['omniauth.auth'] ||= request.env['omniauth.auth']
  end
end
