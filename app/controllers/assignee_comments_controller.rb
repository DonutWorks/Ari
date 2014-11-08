class AssigneeCommentsController < ApplicationController
  def create
    checklist = current_club.notices.friendly.find(params[:notice_id]).checklists.find(params[:checklist_id])
    checklist.assignee_comments.create!(assignee_comments_params)
    redirect_to :back
  end

  def update
    assignee_comment = AssigneeComment.find(params[:id])
    assignee_comment.update!(assignee_comments_params)
    redirect_to :back
  end

  def destroy
    assignee_comment = AssigneeComment.find(params[:id])
    assignee_comment.delete
    redirect_to :back
  end

private
  def assignee_comments_params
    params.require(:assignee_comment).permit(:comment)
  end

end