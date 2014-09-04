class AddShortenUrlToGate < ActiveRecord::Migration
  def change
    add_column :gates, :shortenURL, :string
  end
end
