class UsersController < ApplicationController
  skip_before_filter :authenticate_user!, except: [:show]

  def new
    @user = User.new
    @user_info = auth_hash['info']
  end

  def create
    email = params[:user][:email]
    user = User.find_by_email(email)
    activation = AccountActivation.where(user: user).first_or_initialize(user: user,
     uid: auth_hash['uid'], provider: auth_hash['provider'])
    ticket = ActivationTicket.where(account_activation: activation).first_or_initialize(account_activation: activation,
     code: "testtest")
    # send ticket
    ActivationTicket.transaction do
      activation.save!
      ticket.save!
    end
    raise ticket.inspect
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
    request.env['omniauth.auth'] || session['omniauth.auth']
  end

  def create_session!(user)
    session[:current_user] = user
  end

  def destroy_session!
    session.delete(:current_user)
  end
end
