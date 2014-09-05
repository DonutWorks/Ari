class Admin::ApplicationController < ApplicationController

  skip_before_action :authenticate_user!
  http_basic_authenticate_with name: "habitat", password: "iloveyou"
  protect_from_forgery with: :exception

  def index
    @users = User.all
    @status_list = Gate.all.map do |gate|
      read_users = gate.read_marks.map { |mark| mark.user }
      unread_users = @users.reject {|u| read_users.include?(u)}
      { read_users: read_users, unread_users: unread_users, gate: gate }
    end
  end
end