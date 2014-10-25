class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current_club
  before_action :authenticate_user!

  def default_url_options(options={})
    { redirect_url: params[:redirect_url] }
  end

protected
  def current_club
    @current_club ||= Club.friendly.find(params[:club_id].downcase)
  rescue ActiveRecord::RecordNotFound => e
    not_found
  end
  helper_method :current_club

  def current_user
    @user_session ||= Authenticates::UserSession.new(session)
    return @user_session.user
  end
  helper_method :current_user

  def authenticate_user!
    Authenticates::CookiesSignInService.new(current_club).execute(session, cookies)
    if current_user.nil?
      params[:redirect_url] ||= request.fullpath
      redirect_to club_sign_in_path(current_club)
    elsif !current_user.activated?
      params[:redirect_url] ||= request.fullpath
      redirect_to new_club_invitation_path(current_club)
    elsif current_user.club != current_club
      not_found
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end