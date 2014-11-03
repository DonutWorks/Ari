class Admin::UsersController < Admin::ApplicationController
  respond_to :json

  def index
    @users = User.all.decorate
  end

  def new
    @user = User.new.decorate
  end

  def create
    @user = User.new(user_params)


    if @user.valid?
      associate_user_with_tags!
      @user.save!
      flash[:notice] = "\"#{@user.username}\"님의 회원 정보 생성에 성공했습니다."
      redirect_to admin_users_path
    else
      @user = @user.decorate
      render "new"
    end


  end

  def edit
    @user = User.find(params[:id]).decorate
  end

  def update
    @user = User.find(params[:id])
    @user.assign_attributes(user_params)

    if @user.valid?
      associate_user_with_tags!
      @user.update!(user_params)
      flash[:notice] = "\"#{@user.username}\"님의 회원 정보 수정에 성공했습니다."
      redirect_to admin_user_path(@user)
    else
      @user = @user.decorate
      render 'edit'
    end

  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    flash[:notice] = "\"#{@user.username}\"님의 회원 정보 삭제에 성공했습니다."
    redirect_to admin_users_path
  end

  def show
    @user = User.find(params[:id]).decorate
  end


  def tags
    tags = Tag.fetch_list_by_tag_name(params[:tag_name]).take(5)
    respond_with tags
  end

  def search

    search_word = params[:search_word]

    respond_with User.all if search_word==""
    user_arel = User.arel_table

    tag_arel = Tag.arel_table
    searched_users1 = User.joins(:tags).where(tag_arel[:tag_name].matches("%#{search_word}%"))
    searched_users2 = User.where(user_arel[:username].matches("%#{search_word}%"))

    respond_with (searched_users1 | searched_users2 )
  end

  def get_user

    if params[:id]
      user = User.find(params[:id])
    else
      normalizer = FormNormalizers::PhoneNumberNormalizer.new
      pn = normalizer.normalize(params[:phone_number])
      user = User.find_by_phone_number(pn)
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

    referenced_tags.each do |tag|
      @user.taggings.build(tag_id: tag.id)
    end if referenced_tags != nil
  end

  def extract_tags(user, content)

    referenced = content.strip.split('#')

    referenced.map! do |term|
      next if term.blank?
      term.strip!
      tag = Tag.find_or_create_by(tag_name: term)
    end if !referenced.empty?
    referenced.compact

  end

end