class AddClubIdToTagsAndChecklists < ActiveRecord::Migration
  class Club < ActiveRecord::Base
  end

  class Tag < ActiveRecord::Base
  end

  class Checklist < ActiveRecord::Base
  end

  BELONGS_TO_CLUB = [Tag, Checklist]

  def up
    add_reference :tags, :club, index: true
    add_reference :checklists, :club, index: true

    habitat_club = Club.find_by(name: "SNU-Habitat")
    raise "habitat_club is not existing" if habitat_club.nil?

    BELONGS_TO_CLUB.each do |model|
      model.reset_column_information
      model.find_each do |instance|
        instance.update_attributes!(club_id: habitat_club.id)
      end
    end
  end

  def down
    remove_reference :tags, :club, index: true
    remove_reference :checklists, :club, index: true
  end
end