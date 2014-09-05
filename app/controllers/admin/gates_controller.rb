class Admin::GatesController < Admin::ApplicationController
  def new
    @gate = Gate.new    
  end

  def create
    @gate = Gate.new(gate_params)
    
    if @gate.save
      @gate.shortenURL = @gate.make_shortenURL(gate_url(@gate))
      @gate.save!
      redirect_to admin_gate_path(@gate)
    end
  end

  def show
    @gate = Gate.find(params[:id])
  end

private
  def gate_params
    params.require(:gate).permit(:title, :link, :content)
  end
end
