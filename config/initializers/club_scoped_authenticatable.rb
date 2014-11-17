require 'devise/strategies/database_authenticatable'

module Devise
  module Strategies
    class ClubScopedAuthenticatable < DatabaseAuthenticatable
      def validate(resource, &block)
        result = resource && super

        club_id = params[:club_id].try(:downcase)

        if result && club_id && club_member?(resource, club_id)
          true
        elsif result && club_id.nil?
          # TODO: need to show club list
          true
        else
          fail!(:not_found_in_database)
          false
        end
      end

    private
      def club_member?(resource, club_id)
        current_club = Club.friendly.find(club_id)
        return resource.club == current_club
      end
    end
  end
end

Warden::Strategies.add(:club_scoped_authenticatable, Devise::Strategies::ClubScopedAuthenticatable)