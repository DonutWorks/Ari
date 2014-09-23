class ChangeGenerationIdType < ActiveRecord::Migration

  def up
    users = User.all
    users.each do |user|
      new_generation_id = (user.generation_id||="").delete!("기")
      user.update(:generation_id => new_generation_id)
    end
    change_column :users, :generation_id, :float
  end

  def down
    change_column :users, :generation_id, :string
  end

end
