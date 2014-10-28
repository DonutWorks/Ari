class Admin::ApplicationController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :club_scoped_authenticate_admin_user!
  before_action :current_club
  protect_from_forgery with: :exception

  layout :layout

  def index
    @users = current_club.users.all
    @notices = current_club.notices.all
  end

protected
  def club_scoped_authenticate_admin_user!
    if current_club.nil?
      not_found
    end

    authenticate_admin_user!
    if current_admin_user && current_admin_user.club != current_club
      flash[:error] = "존재하지 않는 동아리입니다."
      redirect_to(request.referer || club_admin_root_path(current_admin_user.club))
    end
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