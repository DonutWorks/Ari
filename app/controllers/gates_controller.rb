class GatesController < ApplicationController
  def show
    @gate = Gate.find(params[:id])
    @gate.mark_as_read!(for: current_user)

    redirect_to @gate.link
  end
end