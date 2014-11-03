class MessageDecorator < Draper::Decorator
  delegate_all
  decorates_association :users, scope: :order_by_gid


  def pretty_created_at
    created_at.localtime.strftime("%Y-%m-%d %T")
  end

end
