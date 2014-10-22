class NoticesController < ApplicationController
  def show
    @notice = Notice.find_by_id(params[:id]) or not_found
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

    # plain -> notices/show
  end
end