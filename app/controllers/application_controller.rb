class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def default_url_options(options={})
    { redirect_url: params[:redirect_url] }
  end

protected
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
  helper_method :current_user

  def authenticate_user!
    authenticate_with_cookie!
    if current_user.nil?
      params[:redirect_url] ||= request.fullpath
      redirect_to sign_in_users_path
    elsif !current_user.activated
      params[:redirect_url] ||= request.fullpath
      redirect_to new_invitation_path
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

private
  def authenticate_with_cookie!
    stored_user_id = cookies.signed[:remember_me]
    if stored_user_id
      user = User.find_by_id(stored_user_id)
      if user
        session[:user_id] = stored_user_id
        return true
      else
        cookies.signed[:remember_me] = nil
      end
    end
    return false
  end
end