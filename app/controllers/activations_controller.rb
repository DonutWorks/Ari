class ActivationsController < AuthenticatableController
	skip_before_action :authenticate_user!
	before_action :require_provider_token, except: :show

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
    if ticket and send_ticket_mail(ticket)
      flash[:notice] = "인증 메일이 전송되었습니다."
    else
      flash[:error] = "인증 메일 전송에 실패했습니다. 다시 시도해주세요."
    end
    redirect_to root_path
	end

	def show
		# TODO: need to matching auth_hash (#184)

		activator = UserActivator.new
    if activator.activate(params[:code])
      flash[:notice] = "카카오톡 인증에 성공하였습니다."
    else
      flash[:error] = "카카오톡 인증에 실패하였습니다."
    end

    # TODO: redirect_to redirect_url (#216)
    redirect_to session.delete(:return_to) || root_path
	end

private
  def send_ticket_mail(ticket)
    verify_url = activation_url(ticket.code)
    mailgun = Mailgun()
    parameters = {
      :from => "ari@donutworks.com",
      :to => ticket.account_activation.user.email,
      :subject => "서울대 햇빛봉사단의 계정 활성화를 위한 메일입니다.",
      :html => "<div><h2>서울대 햇빛봉사단 계정을 활성화 시키려면 아래의 링크를 클릭 해주세요.</h2></div><div>#{verify_url}</div>"
      # :text => <<-BODY
      #   <h2>계정을 활성화 시키려면 아래의 링크를 클릭 해주세요!</h2> :
      #   #{verify_url}
      # BODY
    }
    mailgun.messages.send_email(parameters)
  end
end