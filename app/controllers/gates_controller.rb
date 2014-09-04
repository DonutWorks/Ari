class GatesController < ApplicationController
  def new
    @gate = Gate.new    
  end

  def create
    @gate = Gate.new(gate_params)
    @gate.shortenURL = @gate.make_shortenURL
    if @gate.save
      redirect_to result_gate_path(@gate)
    end
  end

  def result
    @gate = Gate.find(params[:id])
    @shortenURL = @gate.shortenURL

  end

  def show
    @gate = Gate.find(params[:id])
    @gate.mark_as_read!(for: current_user)

    redirect_to @gate.link
  end


  private
  def gate_params
    params.require(:gate).permit(:title, :link, :content, :duedate)
  end

  



end
