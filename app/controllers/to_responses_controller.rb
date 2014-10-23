class ToResponsesController < ApplicationController
  def index
    @notice = current_club.notices.friendly.find(params[:notice_id])
  end

  def create
    notice = current_club.notices.friendly.find(params[:notice_id])

    notice_to_checker = NoticeToChecker.new
    status = notice_to_checker.check(notice)

    response = current_club.responses.new(user: current_user, notice: notice, status: status.to_s)
    if response.save
      flash[:notice] = "참석자로 등록 되었습니다." if status == :go
      flash[:notice] = "대기자로 등록 되었습니다." if status == :wait
    else
      flash[:error] = "잘못된 응답입니다."
    end

    redirect_to club_notice_to_responses_path(current_club, notice)
  end

  def destroy
    notice = current_club.notices.friendly.find(params[:notice_id])

    response = notice.responses.find_by_user_id(current_user)
    response.destroy

    flash[:error] = "응답이 취소 되었습니다."
    redirect_to club_notice_to_responses_path(current_club, notice)
  end

end
