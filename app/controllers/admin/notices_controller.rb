require 'tempfile'
require 'net/http'

class Admin::NoticesController < Admin::ApplicationController

  def new
    @notice = current_club.notices.new
    @users = current_club.users.decorate
    @activity_id = params[:activity_id]
    @init_date = 4.days.from_now.localtime.strftime("%m/%d/%Y")

    20.times { @notice.checklists.build.assign_histories.build }
  end

  def create
    event_at = params[:notice][:event_at].split('/')
    event_at_convert = Date.civil(event_at[2].to_i, event_at[0].to_i, event_at[1].to_i)
    params[:notice][:event_at] = event_at_convert

    @notice = current_club.notices.new(notice_params)
    @notice.checklists.each do |checklist|
      checklist.update(club_id: current_club.id)
    end if @notice.notice_type == "checklist"

    if @notice.save
      shortener = URLShortener.new
      @notice.shortenURL = shortener.shorten_url(club_notice_url(current_club, @notice))
      @notice.save!

      SlackNotifier.notify("햇빛봉사단 게이트 추가 알림 : #{@notice.title}, #{@notice.shortenURL}")
      redirect_to club_admin_notice_path(current_club, @notice)
    else
      @notice.checklists.last.assign_histories.build if @notice.checklist_notice? && !@notice.checklists.empty?
      @users = current_club.users.decorate

      20.times { @notice.checklists.build.assign_histories.build }
      render 'new'
    end
  end

  def show
    @notice = current_club.notices.friendly.find(params[:id]).decorate
    @readers = @notice.club_readers.order_by_read_at.page(params[:readers_page])
    @unreaders = @notice.club_unreaders.generation_sorted_desc.page(params[:unreaders_page])

    if @notice.checklist_notice?
      @assignee_comment = AssigneeComment.new
    elsif @notice.survey_notice?
      @responsed_yes = current_club.users.responsed_yes(@notice).order_by_responsed_at.page(params[:responsed_yes_page])
      @responsed_maybe = current_club.users.responsed_maybe(@notice).order_by_responsed_at.page(params[:responsed_maybe_page])
      @responsed_no = current_club.users.responsed_no(@notice).order_by_responsed_at.page(params[:responsed_no_page])
    elsif @notice.to_notice?
      @responsed_go = current_club.users.responsed_go(@notice).order_by_responsed_at.page(params[:responsed_go_page])
      @responsed_wait = current_club.users.responsed_wait(@notice).order_by_responsed_at.page(params[:responsed_wait_page])
      @responsed_go_percentage = (@responsed_go.count.to_f / @notice.to) * 100

      @dues_sum = @notice.calculate_dues_sum
    end
  end

  def edit
    @notice = current_club.notices.friendly.find(params[:id])
    @users = current_club.users.decorate
    @init_date = @notice.event_at.localtime.strftime("%m/%d/%Y")

    20.times { @notice.checklists.build.assign_histories.build }
  end

  def update
    event_at = params[:notice][:event_at].split('/')
    event_at_convert = Date.civil(event_at[2].to_i, event_at[0].to_i, event_at[1].to_i)
    params[:notice][:event_at] = event_at_convert

    @notice = current_club.notices.friendly.find(params[:id])

    if @notice.update(notice_params)
      flash[:notice] = "\"#{@notice.title}\" 공지를 성공적으로 수정했습니다."
      redirect_to club_admin_notice_path(current_club, @notice)
    else
      @notice.checklists.last.assign_histories.build if @notice.checklist_notice?
      @users = current_club.users.decorate
      20.times { @notice.checklists.build.assign_histories.build}
      render 'edit'
    end
  end

  def destroy
    @notice = current_club.notices.friendly.find(params[:id])
    @notice.destroy

    flash[:notice] = "\"#{@notice.title}\" 공지를 성공적으로 삭제했습니다."
    redirect_to club_admin_root_path(current_club)
  end


  def import
    render 'import'
  end

  def download_roster_example
    send_file(
      "#{Rails.root}/public/RosterExample.xlsx",
      filename: "RosterExample.xlsx",
      type: "application/xlsx"
    )
  end

  def to_notice_end_deadline
    notice = current_club.notices.friendly.find(params[:id])
    if notice.update(due_date: Time.now)
      flash[:notice] = "\"#{notice.title}\" 공지를 성공적으로 마감 했습니다."
      redirect_to club_admin_notice_path(current_club, notice)
    else
      render 'admin/to_responses/index'
    end
  end

  def to_notice_change_deadline
    notice = current_club.notices.friendly.find(params[:id])
    due_date = params.require(:notice).permit(:due_date)
    due_date_convert = Date.civil(due_date['due_date(1i)'].to_i, due_date['due_date(2i)'].to_i, due_date['due_date(3i)'].to_i)

    if notice.update(due_date: due_date_convert)
      flash[:notice] = "\"#{notice.title}\" 공지의 마감일을 성공적으로 수정 했습니다."
      redirect_to club_admin_notice_path(current_club, notice)
    else
      render 'admin/to_responses/index'
    end
  end

  def add_members
    data = ExcelImporter.import(params[:upload][:file])
    data.default_sheet = data.sheets.first

    lastRow = data.last_row
    lastColumn = data.last_column

    User.transaction do
      (2..lastRow).each do |i|
        user = current_club.users.new
        user.username = data.cell(i, 1)
        user.phone_number = data.cell(i, 2)
        user.email = data.cell(i, 3)
        user.major = data.cell(i, 4)
        user.save!
      end
    end

    flash[:notice] = "멤버 입력에 성공했습니다."

  rescue ActiveRecord::StatementInvalid
    flash[:notice] = "멤버 입력에 실패했습니다."
  ensure
    redirect_to club_admin_root_path(current_club)
  end

private
  def notice_params
    params.require(:notice).permit(:title, :link, :content, :notice_type, :to, :event_at, :due_date, :activity_id, :regular_dues, :associate_dues,
      checklists_attributes: [:id, :task, assign_histories_attributes: [:user_id]])
  end
end
