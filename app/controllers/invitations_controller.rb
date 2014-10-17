class InvitationsController < AuthenticatableController
  skip_before_action :require_activated
  before_action :require_signed_in, except: [:create]

  def new
    @user = current_user
  end

  def create
    @user = User.new(user_params)
    @user.extra_info = YAML.load(params[:user][:extra_info]).to_hash

    create_invitation_service = Authenticates::CreateInvitationService.new
    out = create_invitation_service.execute(current_user, @user)

    case out[:status]
    when :invalid_email
      @error_message = "등록된 이메일이 아닙니다. 관리자에게 문의하세요."
      render 'new'
      return
    when :failure
      @error_message = "인증 메일 전송에 실패했습니다. 다시 시도해주세요."
      render 'new'
      return
    when :success
      Authenticates::UserSession.new(session).destroy!
      create_invitation_service.send_invitation_mail(@user.email,
       invitation_url(out[:code], redirect_url: params[:redirect_url]))
      flash[:notice] = "인증 메일이 전송되었습니다."
    end

    proceed
  end

  def show
    code = params[:code]

    out = Authenticates::ActivateUserService.new.execute(current_user, code)

    case out[:status]
    when :failure
      flash[:error] = "카카오톡 인증에 실패하였습니다."
    when :success
      flash[:notice] = "카카오톡 인증에 성공하였습니다."
    end

    proceed
  end

private
  def user_params
    params.require(:user).permit(:email, :uid, :provider)
  end
end