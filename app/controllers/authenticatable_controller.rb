class AuthenticatableController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :require_activated

protected
  def proceed
    redirect_to params.delete(:redirect_url) || club_path(current_club)
  end

  def require_signed_in
    if current_user.nil?
      params[:redirect_url] = request.fullpath
      redirect_to club_sign_in_path(current_club)
      return true
    end
    return false
  end

  def require_activated
    return true if require_signed_in
    if !current_user.activated?
      redirect_to new_club_invitation_path(current_club)
      return true
    end
    return false
  end
end