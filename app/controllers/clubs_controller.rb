class ClubsController < ApplicationController
  def show
  end

  def current_club
    @current_club ||= Club.friendly.find(params[:id].try(:downcase))
  rescue
    nil
  end
end