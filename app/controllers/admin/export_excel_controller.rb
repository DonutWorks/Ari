class Admin::ExportExcelController < Admin::ApplicationController
  require 'open-uri'
  require 'net/http'

  def export
    pattern = "이름/기수/전화번호"

    url = 'http://club.cyworld.com/club/board/common/CommentList.asp?club_id=52252462&board_type=1&board_no=36&item_seq=157146265'
    page = Nokogiri::HTML(open(url).read, nil, 'utf-8')

    column_names = []
    comments = []

    pattern.split('/').each do |e|
      column_names.push e.strip
    end

    page.css('.replylist .obj_rslt').each do |i|
      comment = Hash.new

      i.text.split('/').each_with_index do |e, index|
        hash_value = column_names[index]
        comment[hash_value] = e.strip
      end

      comments.push comment
    end

    respond_to do |format|
      format.html
      format.xls { send_data ExcelExporter.export(comments) }
    end

  end
end