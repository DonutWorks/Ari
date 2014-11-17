class ProvidersController < AuthenticatableController
  prepend_before_action :merge_omniauth_params
  skip_before_action :require_activated
  before_action :disable_footer

  def create
    remember_me = params[:remember_me]
    auth_hash = request.env['omniauth.auth']

    out = Authenticates::KakaoSignInService.new(current_club).execute(session, auth_hash)

    case out[:status]
    when :need_to_register
      @user = User.new({
        uid: auth_hash['uid'],
        provider: auth_hash['provider'],
        extra_info: auth_hash['info']
      })
      render 'invitations/new'
      return
    when :success
      proceed
    end
  end

  def failure
    flash[:error] = "인증에 실패하였습니다."
    proceed
  end

private
  def merge_omniauth_params
    omniauth_params = request.env['omniauth.params']
    params.merge!(omniauth_params) if omniauth_params
  end
end