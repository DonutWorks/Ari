class AuthenticatableController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authenticate!

protected
  def provider_token
    @provider_token ||= ProviderToken.find_by_id(session[:provider_token_id])
  end

  def clear_provider_token!
    session.delete(:provider_token_id)
    @provider_token = nil
  end

  def sign_in_cookie
    cookies.signed[:remember_me]
  end

  def clear_sign_in_cookie!
    cookies.signed[:remember_me] = nil
  end

  def require_provider_token
    if current_user
      redirect_to params.delete(:redirect_url) || root_path
      return
    end

    if provider_token.nil?
      session[:require_provider_token] = true
      params[:redirect_url] = request.fullpath
      redirect_to sign_in_users_path
    end
  end

  def authenticate!
    if current_user || authenticate_with_cookie! || authenticate_with_provider_token!
      session.delete(:provider_token_id)
      redirect_to params.delete(:redirect_url) || root_path
      return true
    end
    return false
  end

  def authenticate_with_provider_token!
    if provider_token
      activation = AccountActivation.find_by(provider_token_id: provider_token.id)

      if activation and activation.activated
        session[:user_id] = activation.user.id
        return true
      else
        redirect_to new_activation_path
      end
    end
    return false
  end

  def authenticate_with_cookie!
    if sign_in_cookie
      user = User.find_by_id(sign_in_cookie)
      if user
        session[:user_id] = sign_in_cookie
        return true
      else
        clear_sign_in_cookie!
      end
    end
    return false
  end
end