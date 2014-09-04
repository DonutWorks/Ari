class SetShortenUrl < ActiveRecord::Migration
  def up
    Gate.all.each do |gate|
      if(gate.shortenURL == nil)
        gate.shortenURL = gate.make_shortenURL
        gate.save
      end
    end
  end

  def down
    Gate.all.each do |gate|
      
      gate.shortenURL = nil
      gate.save
      
    end
  end
end
