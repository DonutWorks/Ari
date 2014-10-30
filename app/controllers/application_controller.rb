class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:index]

  def index
    if current_user
      redirect_to club_path(current_user.club)
    else
      redirect_to sign_in_path
    end
  end

protected
  def default_url_options(options={})
    { redirect_url: params[:redirect_url] }
  end

  def current_club
    @current_club ||= Club.friendly.find(params[:club_id].try(:downcase))
  rescue
    nil
  end
  helper_method :current_club

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
    Authenticates::CookiesSignInService.new(current_club).execute(session, cookies)
    if current_user.nil?
      params[:redirect_url] ||= request.fullpath
      redirect_to club_sign_in_path(current_club)
    elsif !current_user.activated?
      params[:redirect_url] ||= request.fullpath
      redirect_to new_club_invitation_path(current_club)
    elsif current_user.club != current_club
      flash[:error] = "존재하지 않는 동아리입니다."
      redirect_to(request.referer || club_path(current_user.club))
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end