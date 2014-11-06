class ResponseDecorator < Draper::Decorator
  delegate_all

  def responsed_at
    object.created_at.localtime.strftime("%Y-%m-%d %T")
  end


end
