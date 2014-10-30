class ChecklistsController < ApplicationController
  def finish
    current_club.checklists.find(params[:checklist_id]).update(finish: true)
    redirect_to :back
  end
end