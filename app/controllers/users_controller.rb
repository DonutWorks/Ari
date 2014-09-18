class UsersController < ApplicationController
  skip_before_action :authenticate_user!, except: [:show]

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

    flash[:notice] = "Verification mail has been sent."
    redirect_to root_path
  end

  def show
    @user = current_user
  end

  def verify
    ticket = ActivationTicket.find_by_code(params[:code])
    # TODO: handling for nil ticket
    activation = ticket.account_activation
    activation.activated = true
    activation.save!
    redirect_to auth_users_path
  end

private
  def auth_hash
    request.env['omniauth.auth'] || session['omniauth.auth']
  end
end
