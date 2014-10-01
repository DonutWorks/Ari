class AuthenticatableController < ApplicationController
protected
  def require_provider_token
  	redirect_to sign_in_users_path unless provider_token
  end

  def provider_token
  	@provider_token ||= ProviderToken.find_by_id(session[:provider_token_id])
  end

  def authenticate!
    # extendable?
    # require_provider_token
    activation = AccountActivation.find_by(provider_token_id: provider_token.id)

    if activation and activation.activated
      session[:user_id] = activation.user.id
      session.delete(:provider_token_id)
      redirect_to session.delete(:return_to) || root_path
    else
      redirect_to new_activation_path
    end
  end
end