class SessionsController < AuthenticatableController
  skip_before_action :authenticate_user!

  def new
  end

  def destroy
    session.delete(:user_id)
    session.delete(:return_to)
    redirect_to sign_in_users_path
  end
end