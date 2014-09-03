class GatesController < ApplicationController
  def new
    @gate = Gate.new

    
  end
  def create
    @gate = Gate.new(gate_params)
    if @gate.save
      redirect_to new_gate_path
    end
  end

  private
  def gate_params
    params.require(:gate).permit(:title, :link, :content, :duedate)
  end

end
