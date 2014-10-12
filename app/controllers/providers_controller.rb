class ProvidersController < AuthenticatableController
  skip_before_action :require_activated
  before_action :merge_omniauth_params

  def create
    remember_me = params[:remember_me]
    auth_hash = request.env['omniauth.auth']

    out = Authenticates::KakaoSignInService.new.execute(session, auth_hash)

    case out[:status]
    when :need_to_register
      @user = User.new({
        uid: auth_hash['uid'],
        provider: auth_hash['provider'],
        extra_info: auth_hash['info']
      })
      render 'activations/new'
      return
    when :success
      cookies.permanent.signed[:remember_me] = out[:user].id if remember_me
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