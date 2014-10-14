class ToResponsesController < ApplicationController
  def new
    @notice = Notice.find_by_id(params[:notice_id]) or not_found
    @notice_to = Response.where(notice: @notice, status: "go")
  end

  def create
    @notice = Notice.find_by_id(params[:notice_id]) or not_found
    @notice_to = Response.where(notice: @notice, status: "go")

    if @notice.to.to_i > @notice_to.count
      status = "go"
    else
      status = "wait"
    end

    response = Response.new(user: current_user, notice: @notice, status: status)
    if response.save
      flash[:notice] = "응답이 기록되었습니다."
    else
      flash[:error] = "잘못된 응답입니다."
    end

    redirect_to new_notice_to_response_path(@notice)
  end
end
