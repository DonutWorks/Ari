class Admin::ApplicationController < ApplicationController
  skip_before_action :authenticate_user!
  http_basic_authenticate_with name: "habitat", password: "iloveyou"
  protect_from_forgery with: :exception

  layout "admin"

protected
  def admin?
    true
  end
end