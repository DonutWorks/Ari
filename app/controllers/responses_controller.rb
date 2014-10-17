class ResponsesController < ApplicationController
  def index
    @notice = Notice.find_by_id(params[:notice_id]) or not_found

    if current_user.responsed_to?(@notice)
      case @notice.responses.find_by_user_id(current_user).status
      when "yes"
        @status = "당신은 참가 한다고 대답했습니다."   
      when "maybe"
        @status = "당신은 모르겠다고 대답했습니다." 
      when "no"
        @status = "당신은 불참 한다고 대답했습니다." 
      end
    end
  end

  def create
    notice = Notice.find_by_id(params[:notice_id]) or not_found
    response = Response.new(user: current_user, notice: notice, status: params[:status])
    if response.save
      flash[:notice] = "응답이 기록되었습니다."
    else
      flash[:error] = "잘못된 응답입니다."
    end
    redirect_to notice_responses_path(notice)
  end

  def destroy
    notice = Notice.find_by_id(params[:notice_id]) or not_found

    response = notice.responses.find_by_user_id(current_user)
    response.destroy

    flash[:error] = "응답이 취소 되었습니다."
    redirect_to notice_responses_path(notice)
  end
end