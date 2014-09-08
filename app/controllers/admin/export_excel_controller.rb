class Admin::ExportExcelController < Admin::ApplicationController
  require 'open-uri'
  require 'net/http'

  def export
    pattern = "이름/기수/전화번호"

    url = 'http://club.cyworld.com/club/board/common/CommentList.asp?club_id=52252462&board_type=1&board_no=36&item_seq=157146265'
    page = Nokogiri::HTML(open(url).read, nil, 'utf-8')

    column_name = []
    comments = []

    pattern.split('/').each do |e|
      column_name.push e.strip
    end

    comments.push column_name

    page.css('.replylist .obj_rslt').each do |i|
      comment = []

      i.text.split('/').each do |e|
        comment.push e.strip
      end

      comments.push comment
    end


    render text: comments
  end
end