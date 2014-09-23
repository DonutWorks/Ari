class ChangeGenerationIdType < ActiveRecord::Migration

  def up
    users = User.all
    users.each do |user|
      new_generation_id = (user.generation_id||="").delete!("기")
      user.update(:generation_id => new_generation_id)
    end
    if Rails.env.development? or Rails.env.test?
      change_column :users, :generation_id, :float
    else
      change_column :users, :generation_id, 'float USING CAST(generation_id AS float)'
    end

  end

  def down
    if Rails.env.development? or Rails.env.test?
      change_column :users, :generation_id, :string
    else
      change_column :users, :generation_id, 'string USING CAST(generation_id AS string)'
    end

  end

end
