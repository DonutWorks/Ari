class Admin::MessagesController < Admin::ApplicationController
  def index
    @messages = Message.all
  end

  def show
    @message = Message.find(params[:id])
  end

  def create
    message = Message.new
    message.content = params[:sms_content]
    
    if message.save
      params[:sms_user].each do |user|
        message_histories = MessageHistory.new
        message_histories.user_id = user[0]
        message_histories.message_id = message.id

        message_histories.save
      end
      
      redirect_to admin_message_path(message)
    else
      redirect_to admin_gate_path(params[:gate_id])
    end
    
  end

end
