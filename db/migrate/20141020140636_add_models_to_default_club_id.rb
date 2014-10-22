class AddModelsToDefaultClubId < ActiveRecord::Migration
  class AdminUser < ActiveRecord::Base
  end

  class Club < ActiveRecord::Base
  end

  class Invitation < ActiveRecord::Base
  end

  class Message < ActiveRecord::Base
  end

  class Notice < ActiveRecord::Base
  end

  class Response < ActiveRecord::Base
  end

  class User < ActiveRecord::Base
  end

  BELONGS_TO_CLUB = [AdminUser, Invitation, Message, Notice, Response, User]

  def up
    habitat_club = Club.create!(name: "SNU-Habitat", logo_url: "")
    BELONGS_TO_CLUB.each do |model|
      model.reset_column_information
      model.all.each do |instance|
        instance.update_attributes!(club_id: habitat_club.id)
      end
    end
  end

  def down
    habitat_club = Club.find_by(name: "SNU-Habitat")
    habitat_club.destroy

    BELONGS_TO_CLUB.each do |model|
      model.reset_column_information
      model.all.each do |instance|
        instance.update_attributes!(club_id: nil)
      end
    end
  end
end
