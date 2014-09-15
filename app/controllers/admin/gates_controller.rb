require 'tempfile'
require 'net/http'

class Admin::GatesController < Admin::ApplicationController

  def new
    @gate = Gate.new
  end

  def create
    @gate = Gate.new(gate_params)

    if @gate.save
      shortener = URLShortener.new
      @gate.shortenURL = shortener.shorten_url(gate_url(@gate))
      @gate.save!
      redirect_to admin_gate_path(@gate)
    end
  end

  def show
    @gate = Gate.find(params[:id])
  end

  def edit
    @gate = Gate.find(params[:id])
  end

  def update
    @gate = Gate.find(params[:id])

    if @gate.update(gate_params)
      flash[:notice] = @gate.title + " 공지 정보 수정 성공했습니다."
      redirect_to admin_root_path
    else
      flash[:error] = @gate.title + " 공지 정보 수정에 실패하였습니다."
      render 'edit'
    end
  end

  def destroy
    @gate = Gate.find(params[:id])
    flash[:notice] = @gate.title + "공지 삭제를 성공했습니다."
    @gate.destroy

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
          user.password = "testtest"
          user.save!
        end
      end
      flash[:notice] = "멤버 입력을 성공 했습니다."
    rescue ActiveRecord::StatementInvalid
      flash[:notice] = "멤버 입력에 실패 했습니다."
    end

    redirect_to admin_root_path
  end

private
  def gate_params
    params.require(:gate).permit(:title, :link, :content)
  end
end
