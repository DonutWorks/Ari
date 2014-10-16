class StripUsersColumns < ActiveRecord::Migration
  class User < ActiveRecord::Base

  end

  def up
    strip_to = [:username, :email, :major, :student_id, :sex, :home_phone_number, :emergency_phone_number, :habitat_id, :member_type, :birth ]

    User.all.each do |user|
      new_attributes = {}
      strip_to.each { |column| new_attributes[column] = user[column].strip  }
      user.update_attributes!(new_attributes)
    end
  end
  def down
    #nothing to do
  end
end
