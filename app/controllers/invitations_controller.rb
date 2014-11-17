class InvitationsController < AuthenticatableController
  skip_before_action :require_activated
  before_action :require_signed_in, except: [:create]
  before_action :disable_footer

  def new
    @user = current_user
  end

  def create
    @user = current_club.users.new(user_params)
    @user.extra_info = YAML.load(params[:user][:extra_info]).to_hash

    create_invitation_service = Authenticates::CreateInvitationService.new(current_club)
    out = create_invitation_service.execute(current_user, @user)

    case out[:status]
    when :invalid_phone_number
      @error_message = "등록된 전화번호가 아닙니다. 관리자에게 문의하세요."
      render 'new'
      return
    when :failure
      @error_message = "인증 문자 전송에 실패했습니다. 다시 시도해주세요."
      render 'new'
      return
    when :success
      Authenticates::UserSession.new(session).destroy!
      create_invitation_service.send_invitation_sms(@user,
       club_invitation_url(current_club, out[:code], redirect_url: params[:redirect_url]))
      flash[:notice] = "인증 문자가 전송되었습니다."
    end

    proceed
  end

  def show
    code = params[:code]

    out = Authenticates::ActivateUserService.new(current_club).execute(current_user, code)

    case out[:status]
    when :failure
      flash[:error] = "카카오톡 인증에 실패하였습니다."
    when :expired_ticket
      flash[:error] = "이미 만료된 초대장입니다."
    when :success
      flash[:notice] = "카카오톡 인증에 성공하였습니다."
    end

    proceed
  end

private
  def user_params
    params.require(:user).permit(:phone_number, :uid, :provider)
  end
end