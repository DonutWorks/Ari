class ProviderToken < ActiveRecord::Base
	belongs_to :account_activation
	serialize :info
end
