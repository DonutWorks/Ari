class Admin::ApplicationController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :club_scoped_authenticate_admin_user!
  protect_from_forgery with: :exception

  layout :layout

  def index
    @users = current_club.users.all
    @notices = current_club.notices.all
  end

protected
  def club_scoped_authenticate_admin_user!
    authenticate_admin_user!
    if current_admin_user && current_admin_user.club != current_club
      flash[:error] = "권한이 없습니다."
      redirect_to(request.referer || club_admin_root_path(current_admin_user.club))
    end
  end

  def after_sign_out_path_for(resource)
    club_admin_root_path(current_club)
  end

private
  def layout
    if devise_controller?
      nil
    else
      "admin"
    end
  end
end