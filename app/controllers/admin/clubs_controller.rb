class Admin::ClubsController < Admin::ApplicationController
  def edit
    @club = current_club
  end

  def update
    @club = current_club
    @club.assign_attributes(club_params)
    if @club.save
      flash[:notice] = "정보 수정에 성공하였습니다."
      redirect_to club_admin_root_path(current_club)
    else
      render 'edit'
    end
  end

private
  def club_params
    params.require(:club).permit(:logo_url)
  end
end