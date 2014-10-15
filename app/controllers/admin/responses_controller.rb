class Admin::ResponsesController < Admin::ApplicationController
  def index
    @notice = Notice.find_by_id(params[:notice_id])
    # @users = User.all

  end
end
