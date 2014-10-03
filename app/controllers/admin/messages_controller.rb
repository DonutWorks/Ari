class Admin::MessagesController < Admin::ApplicationController
  def index
    @messages = Message.all
  end

  def show
    @message = Message.find(params[:id])
  end

  def create
    sms_sender = SmsSender.new 

    message = sms_sender.send(params[:sms_content], params[:sms_user].keys)

    if message
      flash[:notice] = "회원들에게 문자를 전송 했습니다!"
      redirect_to admin_message_path(message)
    else
      flash[:notice] = "문자 전송에 실패 했습니다. 다시 보내주세요."
      redirect_to admin_gate_path(params[:gate_id])
    end
    
  end

end
