class UsersController < ApplicationController
  skip_before_filter :authenticate_user!, except: [:show]

  def new
    @auth_hash = session['omniauth.auth']
  end

  def create

  end

  def show
  end

  def sign_in
  end

  def sign_out
    destroy_session!
    # temporary
    redirect_to root_path
  end

  def email_sent
  end

  def verify
  end

  def auth
    # extendable?
    activation = AccountActivation.find_by(provider: auth_hash[:provider],
     uid: auth_hash[:uid])

    if activation && activation.activated
      create_session!(activation.user)
      authenticate_user!
    else
      session['omniauth.auth'] = auth_hash
      redirect_to sign_up_users_path
    end
  end

private
  def auth_hash
    request.env['omniauth.auth']
  end

  def create_session!(user)
    session[:current_user] = user
  end

  def destroy_session!
    session.delete(:current_user)
  end
end
