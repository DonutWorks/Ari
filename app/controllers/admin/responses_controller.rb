class Admin::ResponsesController < Admin::ApplicationController
  before_action :find_notice
  def index

  end

  def update

    input_to = 0
    params[:user].each do |key,value|
      if value == "go"
        input_to += 1
      end
    end

    change_history = {"go" => 0, "wait"=> 0, "not"=> 0}

    if input_to > @notice.to
      flash[:alert] = "TO를 초과하였습니다."
      redirect_to admin_notice_responses_path(@notice)
    else

      params[:user].each do |key,value|
        user = User.find_by_id(key)

        if user.response_status(@notice) == "not"
          if value != "not"
            response = Response.new(user: user, notice: @notice, status: value)
            if response.save
              change_history[value] += 1
            end
          end

        else
          response = Response.where(user: user, notice: @notice).first

          if value=="not"
            if response.destroy
              change_history[value] += 1
            end
          elsif response.status != value
            if response.update(status: value)
              change_history[value] += 1
            end
          end
        end

      end

      flash[:notice] = "응답이 수정되었습니다. ( 참가 : #{change_history['go']} / 대기 : #{change_history['wait']} / 미답 : #{change_history['not']} )"
      redirect_to admin_notice_path(@notice)
    end

  end
private
  def find_notice
    @notice = Notice.find_by_id(params[:notice_id])
  end
end