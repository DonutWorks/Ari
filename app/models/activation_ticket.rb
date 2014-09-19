class ActivationTicket < ActiveRecord::Base
  belongs_to :account_activation
  before_create :generate_code

private
  def generate_code
    self.code = loop do
      random_code = SecureRandom.urlsafe_base64(nil, false)
      break random_code unless ActivationTicket.exists?(code: random_code)
    end
  end
end
