class ResponseDecorator < Draper::Decorator
  delegate_all

  def responsed_at
    object.created_at.localtime.strftime("%Y-%m-%d %T")
  end

  def status
    case object.status
    when "yes"
      status = "참가"
    when "maybe"
      status = "모름"
    when "no"
      status = "불참"
    when "go"
      status = "참가"
    when "wait"
      status = "대기"
    when "not"
      status = "불참"  
    end
  end

end
