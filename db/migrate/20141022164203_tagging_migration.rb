class TaggingMigration < ActiveRecord::Migration

  class User < ActiveRecord::Base
    has_many :taggings
    has_many :tags, through: :taggings, source: :tag
  end

  class Tag < ActiveRecord::Base
    has_many :taggings
    has_many :users, through: :taggings, source: :user
  end

  class Tagging < ActiveRecord::Base
    belongs_to :tag
    belongs_to :user
  end

  def pretty_generation_id(generation_id)
    generation_id.to_s.gsub(".0", "") + "기" if generation_id
  end

  def up

    User.all.each do |user|
      terms = [user.major, "#{pretty_generation_id(user.generation_id)}", user.member_type]

      terms.map! do |term|
        next if term.blank?
        term.strip!
        tag = Tag.find_by_tag_name(term) || Tag.create(tag_name: term)
      end if !terms.empty?

      # user.tags.destroy_all

      terms.compact.each do |tag|
        user.taggings.build(tag_id: tag.id)
      end if !terms.empty?
      user.save!

    end

  end
  def down
    User.all.each do |user|
      user.tags.destroy_all
    end
  end


end
