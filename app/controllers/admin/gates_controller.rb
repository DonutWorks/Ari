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
    read_users = User.joins(:read_marks).where(read_marks: {readable: @gate})
    unread_users = User.where.not(id: read_users)
    @status = {
      read_users: read_users,
      unread_users: unread_users
    }
  end

private
  def gate_params
    params.require(:gate).permit(:title, :link, :content)
  end
end
