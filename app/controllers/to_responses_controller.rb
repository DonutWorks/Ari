class ToResponsesController < ApplicationController
  def index
    @notice = Notice.find_by_id(params[:notice_id]) or not_found
  end

  def create
    notice = Notice.find_by_id(params[:notice_id]) or not_found
    responses_go = Response.responsed_to_go(notice)

    if notice.to > responses_go.count
      status = "go"
    else
      status = "wait"
    end

    response = Response.new(user: current_user, notice: notice, status: status)
    if response.save
      flash[:notice] = "참석자로 등록 되었습니다." if status == "go"
      flash[:notice] = "대기자로 등록 되었습니다." if status == "wait"
    else
      flash[:error] = "잘못된 응답입니다."
    end

    redirect_to notice_to_responses_path(notice)
  end

  def destroy
    notice = Notice.find_by_id(params[:notice_id]) or not_found

    response = notice.responses.find_by_user_id(current_user)
    response.destroy

    flash[:error] = "응답이 취소 되었습니다."
    redirect_to notice_to_responses_path(notice)
  end

end
