class ProvidersController < AuthenticatableController
  skip_before_action :authenticate_user!

  def create
    auth_hash = request.env['omniauth.auth']
    provider_token = ProviderToken.find_or_create_by!({
      provider: auth_hash['provider'],
      uid: auth_hash['uid']
    })
    provider_token.update_attributes!(info: auth_hash['info'])

    session[:provider_token_id] = provider_token.id
    if session.delete(:require_provider_token)
      redirect_to session.delete(:return_to)
    else
      authenticate!
    end
  end

  def failure
    flash[:error] = "인증에 실패하였습니다."
    redirect_to session[:return_to] || root_path
  end
end