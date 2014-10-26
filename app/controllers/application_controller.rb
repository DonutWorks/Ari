class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def default_url_options(options={})
    { redirect_url: params[:redirect_url] }
  end

protected
  def current_user
    @user_session ||= Authenticates::UserSession.new(session)
    return @user_session.user
  end
  helper_method :current_user

  def admin?
    false
  end
  helper_method :admin?

  def authenticate_user!
    Authenticates::CookiesSignInService.new.execute(session, cookies)
    if current_user.nil?
      params[:redirect_url] ||= request.fullpath
      redirect_to sign_in_users_path
    elsif !current_user.activated?
      params[:redirect_url] ||= request.fullpath
      redirect_to new_invitation_path
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end