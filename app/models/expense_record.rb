class ExpenseRecord < ActiveRecord::Base
  belongs_to :bank_account
  has_one :response

  validates :record_date, :uniqueness => {:scope => [:deposit, :withdraw, :content]}

  before_destroy :reset_response

  def check_dues
    club = self.bank_account.club
    notices = club.notices.where(notice_type: 'to').where('due_date >= ?', Date.today - 5.days)

    notices.each do |notice|

      if user = club.users.find_by_username(content)
        case user.member_type
        when '예비단원'
          dues = notice.associate_dues
        else
          dues = notice.regular_dues
        end

        if dues == deposit

          response = notice.responses.find_by_user_id(user.id)

          if response and response.dues != 1 and response.update!(dues: 1)
            self.response = response
            return {user: user, activity: notice.activity, dues: dues}
          end
        end

      end
    end
    return
  end

private
  def reset_response
    if self.response
      self.response.update!(dues: 0)
      self.response = nil
      self.save!
    end
  end
end