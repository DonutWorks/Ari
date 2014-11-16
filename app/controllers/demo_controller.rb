class DemoController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    test_clubs = Club.where(demo: true)

    if test_clubs.empty?
      redirect_to root_path
      return
    end

    early_signed_in_club = test_clubs.min_by { |club| club.last_signed_in_at || Date.new(0) }

    sign_in(:admin_user, early_signed_in_club.representive)
    early_signed_in_club.representive.touch(:last_sign_in_at)
    redirect_to club_admin_root_path(early_signed_in_club)
  end
end