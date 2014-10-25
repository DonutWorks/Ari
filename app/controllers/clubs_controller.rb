class ClubsController < ApplicationController
  def show
  end

  def current_club
    @current_club ||= Club.friendly.find(params[:id].downcase)
  rescue ActiveRecord::RecordNotFound => e
    not_found
  end
end