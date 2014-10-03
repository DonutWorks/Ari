class User < ActiveRecord::Base
  has_one :account_activation, dependent: :destroy
  has_many :message_histories
  has_many :messages, through: :message_histories

  validates_presence_of :username, :phone_number, :email
  validates_uniqueness_of :phone_number, :email

  before_validation :normalize_phone_number

  scope :order_by_gid, -> {order(generation_id: :desc)}

  acts_as_reader

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
