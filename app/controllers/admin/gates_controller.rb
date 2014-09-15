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
          user.phonenumber = data.cell(i, 2)
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
