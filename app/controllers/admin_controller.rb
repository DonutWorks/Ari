class AdminController < ApplicationController
  def index
    @users = User.all
    @status_list = Gate.all.map do |gate|
      read_users = gate.read_marks.map { |mark| mark.user }
      unread_users = @users.reject {|u| read_users.include?(u)}
      { read_users: read_users, unread_users: unread_users, gate: gate }
    end
  end
end
