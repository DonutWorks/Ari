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
    @dues_sum = calculate_dues_sum(@activity)
    return @dues_sum
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
    params.require(:activity).permit(:title, :description, :event_at, :regular_dues, :associate_dues)
  end

  def calculate_dues_sum(activity)
    dues_sum = []

    activity.notices.where(notice_type: 'to').each do |notice|
      sum = 0
      go = 0
      wait = 0

      notice.responses.where(dues: 1).each do |response|
        case response.user.member_type
        when "예비단원"
          notice.activity.associate_dues ? sum += notice.activity.associate_dues : sum += 0
        else
          notice.activity.regular_dues ? sum += notice.activity.regular_dues : sum += 0
        end

        case response.status
        when "go"
          go += 1
        when "wait"
          wait += 1
        end
      end

      dues_sum << {notice: notice, go: go, wait: wait, sum: sum}
    end

    return dues_sum
  end
end