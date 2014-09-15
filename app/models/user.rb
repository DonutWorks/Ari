class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:phone_number]

  validates_presence_of :username, :phone_number
  validates_uniqueness_of :phone_number

  before_save :normalize_phone_number

  acts_as_reader

  def read_at(gate)
    read_mark = ReadMark.find_by(user: self, readable: gate)
    return read_mark.timestamp if read_mark
    return nil
  end

protected
	def self.find_for_database_authentication(warden_conditions)
	  conditions = warden_conditions.dup
	  phone_number = conditions.delete(:phone_number)
    find_by_phone_number(phone_number)
	end

  def email_required?
  end

private
  def normalize_phone_number
    normalizer = FormNormalizers::PhoneNumberNormalizer.new
    self.phone_number = normalizer.normalize(phone_number)
  end
end
