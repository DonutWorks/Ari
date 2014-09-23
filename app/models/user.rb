class User < ActiveRecord::Base
  has_one :account_activation, dependent: :destroy

  validates_presence_of :username, :phone_number
  validates_uniqueness_of :phone_number

  before_save :normalize_phone_number

  acts_as_reader

private
  def normalize_phone_number
    normalizer = FormNormalizers::PhoneNumberNormalizer.new
    self.phone_number = normalizer.normalize(phone_number)
  end

end
