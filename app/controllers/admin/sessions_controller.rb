class Admin::SessionsController < Devise::SessionsController
  skip_before_action :club_scoped_authenticate_admin_user!
  prepend_before_action :redirect_admin_user, only: :new

  def new
    disable_footer

    if current_club
      @action = session_path(resource_name)
    else
      @action = admin_sign_in_path
    end

    super
  end

private
  def redirect_admin_user
    if current_admin_user
      redirect_to club_admin_root_path(current_admin_user.club)
    end
  end
end