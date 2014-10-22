class Admin::ApplicationController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authenticate_admin!
  protect_from_forgery with: :exception

  layout :layout

  def index
    @users = User.all
    @notices = Notice.all
  end

private
  def layout
    if devise_controller?
      nil
    else
      "admin"
    end
  end
end