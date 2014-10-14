class ActivationsController < AuthenticatableController
  skip_before_action :authenticate_user!
  before_action :require_provider_token

  def new
    @activation = AccountActivation.new
    @user_info = provider_token.info
  end

  def create
    email = params[:account_activation][:email]
    user = User.find_by_email(email)

    if user.nil?
      flash[:error] = "등록된 이메일이 아닙니다. 관리자에게 문의하세요."
      redirect_to new_activation_path
      return
    end

    activator = UserActivator.new
    ticket = activator.issue_ticket(user, provider_token)
    if ticket and activator.send_ticket_mail(user, activation_url(ticket.code, redirect_url: params[:redirect_url]))
      flash[:notice] = "인증 메일이 전송되었습니다."
    else
      flash[:error] = "인증 메일 전송에 실패했습니다. 다시 시도해주세요."
    end
    redirect_to root_path
  end

  def show
    activator = UserActivator.new
    if activator.activate(params[:code], provider_token)
      flash[:notice] = "카카오톡 인증에 성공하였습니다."
    else
      flash[:error] = "카카오톡 인증에 실패하였습니다."
    end

    authenticate!
  end
end