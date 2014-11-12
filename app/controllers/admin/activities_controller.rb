class Admin::ActivitiesController < Admin::ApplicationController

  def new
    @activity = current_club.activities.new
  end

  def create
    @activity = current_club.activities.new(activity_params)

    if @activity.save
      SlackNotifier.notify("햇빛봉사단이 활동을 추가하였습니다! : #{@activity.title}, #{@activity.description}")
      redirect_to club_admin_root_path(current_club)
    else
      render 'new'
    end
  end

  def index
    @activities = current_club.activities.created_at_desc.decorate
    @users = current_club.users.all
  end

  def show


    @activity = current_club.activities.find(params[:id]).decorate
    @dues_sum = @activity.calculate_dues_sum

  end

  def edit
    @activity = current_club.activities.find(params[:id])
  end

  def update
    @activity = current_club.activities.find(params[:id])

    if @activity.update(activity_params)
      flash[:notice] = "\"#{@activity.title}\" 활동 성공적으로 수정했습니다."
      redirect_to club_admin_root_path(current_club)
    else
      render 'edit'
    end
  end

  def destroy
    @activity = current_club.activities.find(params[:id])
    @activity.destroy

    flash[:notice] = "\"#{@activity.title}\" 활동 성공적으로 삭제했습니다."
    redirect_to club_admin_root_path(current_club)
  end


private
  def activity_params
    params.require(:activity).permit(:title, :description, :event_at)
  end
end