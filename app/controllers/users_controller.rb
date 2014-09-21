class UsersController < ApplicationController
  skip_before_action :authenticate_user!, except: [:show]
  before_action :require_auth_hash, only: [:new, :create]

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
    ticket = activator.issue_ticket(user, auth_hash)
    if ticket && send_ticket_mail(ticket)
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
    if activator.activate(params[:code])
      flash[:notice] = "Activated account!"
    else
      flash[:error] = "Failed to activate account."
    end
    redirect_to auth_users_path
  end

private
  def send_ticket_mail(ticket)
    verify_url = verify_code_users_url(ticket.code)
    mail = Mail.new do
      from 'ari@donutworks.com'
      to ticket.account_activation.user.email
      subject 'Ari Account Activation'
      body <<-BODY
        To activate your account, click on the following link:
        #{verify_url}
      BODY
    end

    mail.delivery_method :sendmail
    mail.deliver
  end
end