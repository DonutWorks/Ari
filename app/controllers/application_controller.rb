class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticated?

  def authenticated?
    if !current_user
      session[:referer] = request.fullpath
      redirect_to new_session_path
    end
  end

  def current_user
    if !session[:user].nil?
      User.find(session[:user])
    end
  end
end
