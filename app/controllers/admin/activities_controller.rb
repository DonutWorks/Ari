class Admin::ActivitiesController < Admin::ApplicationController

  def new
    @activity = current_club.activities.new
    @init_date = 4.days.from_now.localtime.strftime("%m/%d/%Y")
  end

  def create
    event_at = params[:activity][:event_at].split('/')
    event_at_convert = Date.civil(event_at[2].to_i, event_at[0].to_i, event_at[1].to_i)
    params[:activity][:event_at] = event_at_convert

    @activity = current_club.activities.new(activity_params)

    if @activity.save
      SlackNotifier.notify("햇빛봉사단이 이벤트을 추가하였습니다! : #{@activity.title}, #{@activity.description}")
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
  end

  def edit
    @activity = current_club.activities.find(params[:id])
    @init_date = @activity.event_at.localtime.strftime("%m/%d/%Y")
  end

  def update
    @activity = current_club.activities.find(params[:id])

    event_at = params[:activity][:event_at].split('/')
    event_at_convert = Date.civil(event_at[2].to_i, event_at[0].to_i, event_at[1].to_i)
    params[:activity][:event_at] = event_at_convert

    if @activity.update(activity_params)
      flash[:notice] = "\"#{@activity.title}\" 이벤트 성공적으로 수정했습니다."
      redirect_to club_admin_root_path(current_club)
    else
      render 'edit'
    end
  end

  def destroy
    @activity = current_club.activities.find(params[:id])
    @activity.destroy

    flash[:notice] = "\"#{@activity.title}\" 이벤트 성공적으로 삭제했습니다."
    redirect_to club_admin_root_path(current_club)
  end


private
  def activity_params
    params.require(:activity).permit(:title, :description, :event_at)
  end
end