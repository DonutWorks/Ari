class NoticesController < ApplicationController
  def show
    @notice = current_club.notices.friendly.find(params[:id]).decorate
    @assignee_comment = AssigneeComment.new if @notice.notice_type == "checklist"

    current_user.read!(@notice)

    case @notice.notice_type
    when "external"
      redirect_to @notice.link
    when "survey"
      redirect_to club_notice_responses_path(current_club, @notice)
    when "to"
      redirect_to club_notice_to_responses_path(current_club, @notice)
    else
    end
  end
end