class Admin::UsersController < Admin::ApplicationController
  respond_to :json

  def index
    @users = current_club.users.includes(:tags).decorate
  end

  def new
    @user = current_club.users.new.decorate
  end

  def create
    @user = current_club.users.new(user_params)

    if @user.valid?
      associate_user_with_tags!
      @user.save!
      flash[:notice] = "\"#{@user.username}\"님의 멤버 정보 생성에 성공했습니다."
      redirect_to club_admin_users_path(current_club)
    else
      @user = @user.decorate
      render "new"
    end
  end

  def edit
    @user = current_club.users.find(params[:id]).decorate
  end

  def update
    @user = current_club.users.find(params[:id])
    @user.assign_attributes(user_params)

    if @user.valid?
      associate_user_with_tags!
      @user.update!(user_params)
      flash[:notice] = "\"#{@user.username}\"님의 멤버 정보 수정에 성공했습니다."
      redirect_to club_admin_user_path(current_club, @user)
    else
      @user = @user.decorate
      render 'edit'
    end
  end

  def destroy
    @user = current_club.users.find(params[:id])
    @user.destroy

    flash[:notice] = "\"#{@user.username}\"님의 멤버 정보 삭제에 성공했습니다."
    redirect_to club_admin_users_path(current_club)
  end

  def show
    @user = current_club.users.find(params[:id]).decorate
    @public_activities = PublicActivity::Activity.includes(:trackable, :recipient).where(owner: [@user, current_club]).order(created_at: :desc)
  end

  def tags
    tags = current_club.tags.fetch_list_by_tag_name(params[:tag_name]).take(5)
    respond_with tags
  end

  def search
    search_word = params[:search_word]

    respond_with current_club.users.all if search_word == ""
    user_arel = current_club.users.arel_table

    tag_arel = current_club.tags.arel_table
    searched_users1 = current_club.users.joins(:tags).where(tag_arel[:tag_name].matches("%#{search_word}%"))
    searched_users2 = current_club.users.where(user_arel[:username].matches("%#{search_word}%"))

    respond_with (searched_users1 | searched_users2 )
  end

  def get_user
    if params[:id]
      user = current_club.users.find(params[:id])
    else
      normalizer = FormNormalizers::PhoneNumberNormalizer.new
      pn = normalizer.normalize(params[:phone_number])
      user = current_club.users.find_by_phone_number(pn)
    end

    respond_to do |format|
      format.text { render :json => user }
    end
  end


private
  def user_params
    params.require(:user).permit(:username, :email, :phone_number, :major, :student_id, :sex, :home_phone_number, :emergency_phone_number, :habitat_id, :member_type, :generation_id, :birth)
  end

  def associate_user_with_tags!
    referenced_tags = extract_tags(@user, params[:tags])

    @user.tags.destroy_all

    referenced_tags.uniq.each do |tag|
      @user.taggings.build(tag_id: tag.id)
    end if referenced_tags != nil
  end

  def extract_tags(user, content)
    referenced = content.strip.split('#')

    referenced.map! do |term|
      next if term.blank?
      term.strip!
      tag = current_club.tags.find_or_create_by(tag_name: term)
    end if !referenced.empty?

    referenced.compact
  end
end