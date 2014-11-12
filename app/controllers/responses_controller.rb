class ResponsesController < ApplicationController
  def index
    @notice = current_club.notices.friendly.find(params[:notice_id]).decorate

    if current_user.responsed_to?(@notice)
      case @notice.responses.find_by_user_id(current_user).status
      when "yes"
        @status = "참가"
      when "maybe"
        @status = "모름"
      when "no"
        @status = "불참"
      end
    end
  end

  def create
    notice = current_club.notices.friendly.find(params[:notice_id])

    response = current_club.responses.find_by_user_id_and_notice_id(current_user.id, notice.id)
    response = current_club.responses.new(user: current_user, notice: notice) unless response

    response.status = params[:status]

    if response.save
      flash[:notice] = "응답이 기록되었습니다."
    else
      flash[:error] = "잘못된 응답입니다."
    end
    redirect_to club_notice_responses_path(current_club, notice)
  end

  def destroy
    notice = current_club.notices.friendly.find(params[:notice_id])

    response = notice.responses.find_by_user_id(current_user)
    response.destroy

    flash[:error] = "응답이 취소 되었습니다."
    redirect_to club_notice_responses_path(current_club, notice)
  end
end