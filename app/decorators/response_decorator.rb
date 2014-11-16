class ResponseDecorator < Draper::Decorator
  delegate_all

  def responsed_at
    object.created_at.localtime.strftime("%Y-%m-%d %T")
  end

  def status
    case object.status
    when "yes"
      status = "찬성"
    when "maybe"
      status = "보류"
    when "no"
      status = "반대"
    when "go"
      status = "참가"
    when "wait"
      status = "대기"
    when "not"
      status = "불참"
    end
  end

end
