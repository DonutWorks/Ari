class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :rememberable, :trackable, :validatable #:recoverable

  validates_presence_of :club_id, :name, :phone_number

  belongs_to :club
end
