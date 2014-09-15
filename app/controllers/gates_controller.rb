class GatesController < ApplicationController
  def show
    @gate = Gate.find(params[:id])
    current_user.read!(@gate)

    redirect_to @gate.link
  end
end

