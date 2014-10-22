class UserTagMigration < ActiveRecord::Migration

  class User < ActiveRecord::Base
    has_many :user_user_tags
    has_many :tags, through: :user_user_tags, source: :user_tag
  end

  class UserTag < ActiveRecord::Base
    has_many :user_user_tags
    has_many :users, through: :user_user_tags, source: :user
  end

  class UserUserTag < ActiveRecord::Base
    belongs_to :user_tag
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
        user_tag = UserTag.find_by_tag_name(term) || UserTag.create(tag_name: term)
      end if !terms.empty?

      # user.tags.destroy_all

      terms.compact.each do |tag|
        user.user_user_tags.build(user_tag_id: tag.id)
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
