class AuthenticatableController < ApplicationController
protected
  def require_auth_hash
    if auth_hash.nil?
      redirect_to sign_in_users_path
		end
  end

  # need to dispatch for each provider (also view), but not now.
  def auth_hash
    session['omniauth.auth'] ||= request.env['omniauth.auth'].slice('provider', 'uid', 'info')
  end
end