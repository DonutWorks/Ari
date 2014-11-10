class AddClubToActivitiesAndBankAccounts < ActiveRecord::Migration
  class Club < ActiveRecord::Base
  end

  class Activity < ActiveRecord::Base
    belongs_to :club
  end

  class BankAccount < ActiveRecord::Base
  end

  def up
    raise "Need default club (SNU-Habitat)" if Club.first.nil?
    default_club = Club.first

    add_reference :activities, :club, index: true
    add_reference :bank_accounts, :club, index: true

    Activity.reset_column_information
    BankAccount.reset_column_information

    Activity.find_each do |activity|
      activity.update_attributes!(club_id: default_club.id)
    end

    BankAccount.find_each do |bank_account|
      bank_account.update_attributes!(club_id: default_club.id)
    end
  end

  def down
    remove_reference :activities, :club
    remove_reference :bank_accounts, :club
  end
end
