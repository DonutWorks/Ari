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

        user = User.find(user[0])

        sms_info = {
          from: "114", #보내는 사람
          to: user.phone_number, #받는 사람
          user: "donutworks",
          password: "donutwork1!",
          text: "[서울대 햇빛봉사단]" + message.content #SMS내용
        }

        sms_sender = SendSMS.new
        if sms_sender.send_sms(sms_info)

          message_histories = MessageHistory.new
          message_histories.user_id = user.id
          message_histories.message_id = message.id

          message_histories.save

        else

        end
      end
      
      redirect_to admin_message_path(message)
    else
      redirect_to admin_gate_path(params[:gate_id])
    end
    
  end

end
