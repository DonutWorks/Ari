class AssigneeCommentsController < ApplicationController
  def create
    ac = Notice.find(params[:notice_id]).checklists.find(params[:checklist_id]).assignee_comments.build(assignee_comments_params)

    if ac.save
      redirect_to :back
    else
      raise ac.errors
      redirect_to notice_path(18)
    end
  end

private
  def assignee_comments_params
    params.require(:assignee_comment).permit(:comment)
  end

end