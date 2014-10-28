class Admin::ActivitiesController < Admin::ApplicationController

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)

    if @activity.save
      SlackNotifier.notify("햇빛봉사단 게이트 추가 알림 : #{@activity.title}, #{@activity.description}")
      redirect_to admin_root_path
    else
      render 'new'
    end
  end

  def index
    @activities = Activity.all
    @users = User.all
  end


private
  def activity_params
    params.require(:activity).permit(:title, :description, :event_at)
  end
end