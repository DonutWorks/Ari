class Admin::MessagesController < Admin::ApplicationController
  def index
    @messages = Message.all
  end

  def show
    @message = Message.find(params[:id])
  end

  def create
    sms_sender = SmsSender.new 

    begin
      message = sms_sender.send_message(params[:sms_content], params[:sms_user].keys)  
    rescue SmsSender::SMSSenderError => e
      flash[:notice] = e.message
      redirect_to admin_gate_path(params[:gate_id])
    else
      flash[:notice] = "회원들에게 문자를 전송 했습니다!"
      redirect_to admin_message_path(message)
    end
    
  end

end
