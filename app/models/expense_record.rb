class ExpenseRecord < ActiveRecord::Base
  belongs_to :account

  validates :record_date, :uniqueness => {:scope => [:deposit, :withdraw, :content]}

  def check_dues
    notices = Notice.where(notice_type: 'to').where('due_date >= ?', Date.today - 5.days)

    notices.each do |notice|
      if user = User.find_by_username(content)
        case user.member_type
        when '예비단원'
          dues = notice.associate_dues
        else
          dues = notice.regular_dues
        end

        if dues == deposit
          response = notice.responses.find_by_user_id(user.id)
          return {username: user.username, member_type: user.member_type, dues: deposit, notice_title: notice.title} if response.update!(dues: 1)
        end        
      end
    end
    return
  end
end