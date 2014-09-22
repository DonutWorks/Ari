class Admin::ApplicationController < ApplicationController
  skip_before_action :authenticated?
  http_basic_authenticate_with name: "habitat", password: "iloveyou"
  protect_from_forgery with: :exception

  layout "admin"

  def index
    @users = User.all
    @gates = Gate.all
  end


end