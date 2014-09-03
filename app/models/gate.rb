class Gate < ActiveRecord::Base
  acts_as_readable on: :created_at
end
