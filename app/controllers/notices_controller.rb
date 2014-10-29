class NoticesController < ApplicationController
  def show
    @notice = Notice.find_by_id(params[:id]).decorate or not_found
    @assignee_comment = AssigneeComment.new if @notice.notice_type == "checklist"

    current_user.read!(@notice)

    case @notice.notice_type
    when "external"
      redirect_to @notice.link
    when "survey"
      redirect_to notice_responses_path(@notice)
    when "to"
      redirect_to notice_to_responses_path(@notice)
    else

    end

    # plain -> notices/show
  end
end