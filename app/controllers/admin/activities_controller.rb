class Admin::ActivitiesController < Admin::ApplicationController
  def index
    @users = User.all
    @notices = Notice.order('created_at DESC')
  end
end