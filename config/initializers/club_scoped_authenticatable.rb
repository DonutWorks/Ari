require 'devise/strategies/database_authenticatable'

module Devise
  module Strategies
    class ClubScopedAuthenticatable < DatabaseAuthenticatable
      def validate(resource, &block)
        result = resource && super

        if result && club_member?(resource)
          true
        else
          fail!(:not_found_in_database)
          false
        end
      end

    private
      def club_member?(resource)
        current_club = Club.friendly.find(params[:club_id].downcase)
        return resource.club == current_club
      end
    end
  end
end

Warden::Strategies.add(:club_scoped_authenticatable, Devise::Strategies::ClubScopedAuthenticatable)