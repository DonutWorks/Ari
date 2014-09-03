class AdminController < ApplicationController
  skip_before_action :authenticate_user!
  http_basic_authenticate_with name: "habitat", password: "iloveyou"

  def index
    
  end

end
