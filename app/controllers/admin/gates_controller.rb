class Admin::GatesController < Admin::ApplicationController
  def new
    @gate = Gate.new    
  end

  def create
    @gate = Gate.new(gate_params)
    
    if @gate.save
      @gate.shortenURL = @gate.make_shortenURL(gate_url(@gate))
      @gate.save!
      redirect_to result_admin_gate_path(@gate)
    end
  end

  def result
    @gate = Gate.find(params[:id])
    @shortenURL = @gate.shortenURL
  end

private
  def gate_params
    params.require(:gate).permit(:title, :link, :content, :duedate)
  end
end
