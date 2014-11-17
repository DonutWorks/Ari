class Admin::SessionsController < Devise::SessionsController
  skip_before_action :club_scoped_authenticate_admin_user!

  def new
    if current_club
      @action = session_path(resource_name)
    else
      @action = admin_sign_in_path
    end

    super
  end
end