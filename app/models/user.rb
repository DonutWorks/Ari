class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:username]

  validates_presence_of :username

  acts_as_reader

	protected
	def self.find_for_database_authentication(warden_conditions)
	  conditions = warden_conditions.dup
	  username = conditions.delete(:username)
    find_by_username(username)
	end

  def email_required?
  end
end
