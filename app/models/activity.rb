class Activity < ActiveRecord::Base
  has_many :notices, :dependent => :destroy
end
