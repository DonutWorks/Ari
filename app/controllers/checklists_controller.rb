class ChecklistsController < ApplicationController
  def finish
    checklist = current_club.checklists.find(params[:checklist_id])

    if checklist.update_column(:finish, true)
      checklist.create_activity(:finish, owner: checklist.assignees.first)
    end

    redirect_to :back
  end
end