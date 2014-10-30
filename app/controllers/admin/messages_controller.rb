class Admin::MessagesController < Admin::ApplicationController
  def index
    @messages = current_club.messages.created_at_sorted_desc
  end

  def new
    @message = current_club.messages.new
    @users = current_club.users.all
  end

  def show
    @message = current_club.messages.find(params[:id])
  end

  def create
    content = params[:sms_content]
    notice_id = params[:notice_id]
    user_ids = params[:sms_user].keys

    out = Admin::Messages::SendMessageService.new(current_club).execute(content, notice_id, user_ids)

    case out[:status]
    when :failure
      flash[:error] = "현재 message를 보낼 수 없습니다. 다음에 다시 시도해주세요."
      redirect_to club_admin_notice_path(current_club, notice_id)
    when :success
      flash[:notice] = "회원들에게 문자를 전송 했습니다!"
      redirect_to club_admin_message_path(current_club, out[:message])
    end
  end
end
