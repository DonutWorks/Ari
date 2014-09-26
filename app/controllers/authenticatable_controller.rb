class AuthenticatableController < ApplicationController
protected
  def require_auth_hash
    if auth_hash.nil?
      redirect_to sign_in_users_path
		end
  end

  def auth_hash
    session['omniauth.auth'] ||= request.env['omniauth.auth']
  end
end