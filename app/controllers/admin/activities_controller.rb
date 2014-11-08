class Admin::ActivitiesController < Admin::ApplicationController

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)

    if @activity.save
      SlackNotifier.notify("햇빛봉사단이 활동을 추가하였습니다! : #{@activity.title}, #{@activity.description}")
      redirect_to admin_root_path
    else
      render 'new'
    end
  end

  def index
    @activities = Activity.created_at_desc.decorate
    @users = User.all
  end

  def show
    @activity = Activity.find(params[:id]).decorate
  end

  def edit
    @activity = Activity.find(params[:id])
  end

  def update
    @activity = Activity.find(params[:id])

    if @activity.update(activity_params)
      flash[:notice] = "\"#{@activity.title}\" 활동 성공적으로 수정했습니다."
      redirect_to admin_root_path
    else
      render 'edit'
    end
  end

  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy

    flash[:notice] = "\"#{@activity.title}\" 활동 성공적으로 삭제했습니다."
    redirect_to admin_root_path
  end


private
  def activity_params
    params.require(:activity).permit(:title, :description, :event_at)
  end
end