class AssigneeCommentsController < ApplicationController
  def create
    Notice.find(params[:notice_id]).checklists.find(params[:checklist_id]).assignee_comments.create(assignee_comments_params)
    redirect_to :back
  end

  def update
    AssigneeComment.find(params[:id]).update(assignee_comments_params)
    redirect_to :back
  end

  def destroy
    AssigneeComment.find(params[:id]).delete
    redirect_to :back
  end

private
  def assignee_comments_params
    params.require(:assignee_comment).permit(:comment)
  end

end