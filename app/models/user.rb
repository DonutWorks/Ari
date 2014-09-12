class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:phonenumber]

  validates_presence_of :username, :phonenumber
  validates_uniqueness_of :phonenumber

  acts_as_reader

protected
	def self.find_for_database_authentication(warden_conditions)
	  conditions = warden_conditions.dup
	  phonenumber = conditions.delete(:phonenumber)
    find_by_phonenumber(phonenumber)
	end

  def email_required?
  end
end
