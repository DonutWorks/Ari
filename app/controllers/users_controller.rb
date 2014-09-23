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
      redirect_to sign_up_users_path
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
    mailgun = Mailgun()
    parameters = {
      :from => "ari@donutworks.com",
      :to => ticket.account_activation.user.email,
      :subject => "Ari 계정 활성화 메일 보내드립니다.",
      :html => "<div><h2>Ari의 계정을 활성화 시키려면 아래의 링크를 클릭 해주세요.</h2></div><div>#{verify_url}</div>"
      # :text => <<-BODY
      #   <h2>계정을 활성화 시키려면 아래의 링크를 클릭 해주세요!</h2> :
      #   #{verify_url}
      # BODY
    }
    mailgun.messages.send_email(parameters)
  end
end