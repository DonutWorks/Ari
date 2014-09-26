class SessionsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :require_auth_hash, only: [:create]

  def new
  end

  def create
    authenticate!
  end

  def destroy
    destroy_session!
    redirect_to sign_in_users_path
  end

private
  def authenticate!
  # extendable?
    activation = AccountActivation.find_by(provider: auth_hash['provider'],
     uid: auth_hash['uid'])

    if activation && activation.activated
      create_session!(activation.user)
      redirect_to session.delete(:return_to) || root_path
    else
      redirect_to sign_up_users_path
    end
  end

  def create_session!(user)
    session[:user_id] = user.id
  end

  def destroy_session!
    session.delete(:user_id)
  end
end
