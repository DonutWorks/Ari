class AuthenticatableController < ApplicationController
  skip_before_action :authenticate_user!

protected
  def require_provider_token
    if provider_token.nil?
      session[:require_provider_token] = true
      params[:redirect_url] = request.fullpath
      redirect_to sign_in_users_path
    end
  end

  def provider_token
    @provider_token ||= ProviderToken.find_by_id(session[:provider_token_id])
  end

  def authenticate!
    # require_provider_token
    activation = AccountActivation.find_by(provider_token_id: provider_token.id)

    if activation and activation.activated
      session[:user_id] = activation.user.id
      session.delete(:provider_token_id)
      redirect_to params.delete(:redirect_url) || root_path
    else
      redirect_to new_activation_path
    end
  end
end