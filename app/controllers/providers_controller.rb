class ProvidersController < AuthenticatableController
  skip_before_action :authenticate!

  def create
    params.merge!(request.env['omniauth.params'])
    remember_me = params[:remember_me]

    auth_hash = request.env['omniauth.auth']
    provider_token = ProviderToken.find_or_create_by!({
      provider: auth_hash['provider'],
      uid: auth_hash['uid']
    })
    provider_token.update_attributes!(info: auth_hash['info'])

    session[:provider_token_id] = provider_token.id
    if session.delete(:require_provider_token)
      redirect_to params.delete(:redirect_url) || root_path
    else
      authenticate!(remember_me: remember_me)
    end
  end

  def failure
    params.merge!(request.env['omniauth.params'])
    flash[:error] = "인증에 실패하였습니다."
    redirect_to params[:redirect_url] || root_path
  end
end