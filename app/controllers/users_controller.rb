class UsersController < ApplicationController
  skip_before_action :authenticate_user!, except: [:show]

  def new
    @user = User.new
    @user_info = auth_hash['info']
  end

  def create
    email = params[:user][:email]
    user = User.find_by_email(email)

    if user.nil?
      flash[:error] = "Please check your email."
      render 'new'
      return
    end

    activator = UserActivator.new
    if activator.issue_ticket(user, auth_hash)
      flash[:notice] = "Verification mail has been sent."
    else
      flash[:error] = "Failed to send verification mail. Please retry."
    end
    redirect_to root_path
  end

  def show
    @user = current_user
  end

  def verify
    activator = UserActivator.new
    if !activator.activate(params[:code])
      flash[:error] = "Failed to activate account."
    end
    redirect_to auth_users_path
  end

private
  def auth_hash
    request.env['omniauth.auth'] || session['omniauth.auth']
  end
end