class User < ActiveRecord::Base
  has_one :account_activation, dependent: :destroy

  validates_presence_of :username, :phone_number, :email
  validates_uniqueness_of :phone_number, :email

  before_validation :normalize_phone_number

  acts_as_reader

  def activated?
    return false unless account_activation
    account_activation.activated
  end

private
  def normalize_phone_number
    normalizer = FormNormalizers::PhoneNumberNormalizer.new
    begin
      self.phone_number = normalizer.normalize(phone_number) if !phone_number.blank?
    rescue FormNormalizers::NormalizeError => e
      errors.add(:phone_number, "가 잘못되었습니다.")
    end
  end
end