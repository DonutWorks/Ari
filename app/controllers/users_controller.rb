class UsersController < ApplicationController
  def new
  end

  def create
  end

  def show
  end

  def sign_in
  end

  def email_sent
  end

  def verify
  end

  def auth
  end

private
  def auth_hash
    request.env['omniauth.auth']
  end
end
