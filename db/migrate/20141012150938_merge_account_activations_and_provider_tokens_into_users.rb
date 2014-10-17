class MergeAccountActivationsAndProviderTokensIntoUsers < ActiveRecord::Migration

  class User < ActiveRecord::Base
    has_one :account_activation
    serialize :extra_info
  end

  class AccountActivation < ActiveRecord::Base
    belongs_to :user
    has_many :activation_ticket # remove dependent
    has_one :provider_token
  end

  class ProviderToken < ActiveRecord::Base
    belongs_to :account_activation
    serialize :info
  end

  class ActivationTicket < ActiveRecord::Base
    belongs_to :account_activation
  end

  def up
    add_column :users, :activated, :boolean, default: false
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    # from provider
    add_column :users, :extra_info, :text
    add_column :activation_tickets, :user_id, :integer

    User.reset_column_information
    AccountActivation.reset_column_information
    ProviderToken.reset_column_information
    ActivationTicket.reset_column_information

    AccountActivation.all.each do |activation|
      # provider_token, account_activation -> user
      user = activation.user
      next unless user

      attributes = {}
      attributes[:activated] = activation.activated

      token = ProviderToken.find_by_id(activation.provider_token_id)
      attributes.merge!({
        provider: token.provider,
        uid: token.uid,
        extra_info: token.info
      }) if token

      user.update_attributes!(attributes)

      # update activation_ticket
      activation.activation_ticket.each do |ticket|
        ticket.update_attributes!(user_id: user.id)
      end
    end

    remove_column :activation_tickets, :account_activation_id
    drop_table :account_activations
    drop_table :provider_tokens
  end

  def down
    create_table :account_activations do |t|
      t.references :user, index: true
      t.references :provider_token
      t.boolean :activated, default: false

      t.timestamps
    end

    create_table :provider_tokens do |t|
      t.string :provider
      t.string :uid
      t.text :info

      t.timestamps
    end

    add_column :activation_tickets, :account_activation_id, :integer

    User.reset_column_information
    AccountActivation.reset_column_information
    ProviderToken.reset_column_information
    ActivationTicket.reset_column_information

    User.all.each do |user|
      next if user.provider.nil?

      token = ProviderToken.create!({
        provider: user.provider,
        uid: user.uid,
        info: user.extra_info
      })
      activation = AccountActivation.create!({
        user_id: user.id,
        activated: user.activated,
        provider_token_id: token.id
      })

      ActivationTicket.where(user_id: user.id).each do |ticket|
        ticket.update_attributes!(account_activation_id: activation.id)
      end
    end

    remove_column :users, :activated
    remove_column :users, :provider
    remove_column :users, :uid
    remove_column :users, :extra_info
    remove_column :activation_tickets, :user_id
  end
end
