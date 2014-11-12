class ClubsController < ApplicationController
  def show
    @responses = current_user.responses.decorate
  end

  def current_club
    @current_club ||= Club.friendly.find(params[:id].try(:downcase))
  rescue
    nil
  end
end