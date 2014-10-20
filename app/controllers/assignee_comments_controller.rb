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