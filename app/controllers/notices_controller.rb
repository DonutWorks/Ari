class NoticesController < ApplicationController
  def show
    @notice = Notice.find(params[:id])
    current_user.read!(@notice)

    redirect_to @notice.link
  end
end