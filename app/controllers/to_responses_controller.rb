class ToResponsesController < ApplicationController
  def new
    @notice = Notice.find_by_id(params[:notice_id]) or not_found
  end

  def create
    @notice = Notice.find_by_id(params[:notice_id]) or not_found

    if @notice.to.to_i > @notice.responses.where(status: "go").count
      status = "go"
    else
      status = "wait"
    end

    response = Response.new(user: current_user, notice: @notice, status: status)
    if response.save
      flash[:notice] = "참석자로 등록 되었습니다." if status == "go"
      flash[:notice] = "대기자로 등록 되었습니다." if status == "wait"
    else
      flash[:error] = "잘못된 응답입니다."
    end

    redirect_to new_notice_to_response_path(@notice)
  end
end
