class ResponseDecorator < Draper::Decorator
  delegate_all

  def responsed_at
    created_at.localtime.strftime("%Y-%m-%d %T")
  end


end
