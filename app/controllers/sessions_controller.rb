class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

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
  def auth_hash
    request.env['omniauth.auth'] || session['omniauth.auth']
  end

  def authenticate!
  # extendable?
    activation = AccountActivation.find_by(provider: auth_hash['provider'],
     uid: auth_hash['uid'])

    if activation && activation.activated
      create_session!(activation.user)
      redirect_to session.delete(:return_to) || root_path
    else
      session['omniauth.auth'] = auth_hash
      redirect_to sign_up_users_path
    end
  end

  def create_session!(user)
    session[:current_user] = user.id
  end

  def destroy_session!
    session.delete(:current_user)
  end
end