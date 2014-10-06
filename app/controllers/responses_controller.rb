class ResponsesController < ApplicationController
  def new
    @notice = Notice.find_by_id(params[:notice_id]) or not_found
  end

  def create
    @notice = Notice.find_by_id(params[:notice_id]) or not_found
    response = Response.new(user: current_user, notice: @notice, status: params[:status])
    if response.save
      flash[:notice] = "응답이 기록되었습니다."
    else
      flash[:error] = "잘못된 응답입니다."
    end
    redirect_to new_notice_response_path(@notice)
  end
end