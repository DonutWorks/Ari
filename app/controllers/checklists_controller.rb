class ChecklistsController < ApplicationController
  def finish
    Checklist.find(params[:checklist_id]).update(finish: true)
    redirect_to :back
  end
end