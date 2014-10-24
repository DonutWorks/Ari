require 'tempfile'
require 'net/http'

class Admin::NoticesController < Admin::ApplicationController

  def new
    @notice = Notice.new
    20.times { @notice.checklists.build.assign_histories.build }
  end

  def create
    @notice = Notice.new(notice_params)

    if @notice.save
      shortener = URLShortener.new
      @notice.shortenURL = shortener.shorten_url(notice_url(@notice))
      @notice.save!

      SlackNotifier.notify("햇빛봉사단 게이트 추가 알림 : #{@notice.title}, #{@notice.shortenURL}")
      redirect_to admin_notice_path(@notice)
    else
      @notice.checklists.last.assign_histories.build if @notice.checklist_notice?
      20.times { @notice.checklists.build.assign_histories.build }
      render 'new'
    end
  end

  def show
    @notice = Notice.find(params[:id])
    @assignee_comment = AssigneeComment.new if @notice.notice_type == "checklist"
  end

  def edit
    @notice = Notice.find(params[:id])
    20.times { @notice.checklists.build.assign_histories.build}
  end

  def update
    @notice = Notice.find(params[:id])

    if @notice.update(notice_params)
      flash[:notice] = "\"#{@notice.title}\" 공지를 성공적으로 수정했습니다."
      redirect_to admin_notice_path(@notice)
    else
      @notice.checklists.last.assign_histories.build if @notice.checklist_notice?
      20.times { @notice.checklists.build.assign_histories.build}
      render 'edit'
    end
  end

  def destroy
    @notice = Notice.find(params[:id])
    @notice.destroy

    flash[:notice] = "\"#{@notice.title}\" 공지를 성공적으로 삭제했습니다."
    redirect_to admin_root_path
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

  def add_members
    data = ExcelImporter.import(params[:upload][:file])
    data.default_sheet = data.sheets.first

    lastRow = data.last_row
    lastColumn = data.last_column

    begin
      User.transaction do
        (2..lastRow).each do |i|
          user = User.new
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
    end

    redirect_to admin_root_path
  end

private
  def notice_params
    params.require(:notice).permit(:title, :link, :content, :notice_type, :to, :due_date,
      checklists_attributes: [:id, :task, assign_histories_attributes: [:user_id]])
  end
end
