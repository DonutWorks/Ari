class ClubsController < ApplicationController
  def show
    @public_activities = PublicActivity::Activity.where(owner: [current_user, current_club]).order(created_at: :desc)
  end

  def current_club
    @current_club ||= Club.friendly.find(params[:id].try(:downcase))
  rescue
    nil
  end
end