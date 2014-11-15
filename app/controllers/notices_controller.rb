class NoticesController < ApplicationController
  def show
    @notice = current_club.notices.friendly.find(params[:id]).decorate
    @assignee_comment = AssigneeComment.new if @notice.raw_notice_type == "checklist"

    create_read_activity!(current_user, @notice)

    case @notice.raw_notice_type
    when "external"
      redirect_to @notice.link
    when "survey"
      redirect_to club_notice_responses_path(current_club, @notice)
    when "to"
      redirect_to club_notice_to_responses_path(current_club, @notice)
    else
    end
  end

private
  def create_read_activity!(user, notice)
    return if user.read?(notice)

    user.read!(notice)
    # public activity
    user.create_activity(:read_notice, owner: user, recipient: notice)
  end
end