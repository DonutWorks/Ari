class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :club
  before_create :generate_code

private
  def generate_code
    self.code ||= loop do
      random_code = SecureRandom.urlsafe_base64(nil, false)
      break random_code unless Invitation.exists?(code: random_code)
    end
  end
end
