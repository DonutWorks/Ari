class CyworldURL
  def initialize(shorten_url)
    @shorten_url = shorten_url
  end

  def to_comment_view_url
    shorten_url_template = URITemplate.new("http://{host}{/segments*}")
    params = shorten_url_template.extract(@shorten_url)["segments"]
    query_params = {
      club_id: params[0][0..7],
      board_type: params[0][8],
      board_no: params[0][9..-1],
      item_seq: params[1]
    }
    comment_list_url = "http://club.cyworld.com/club/board/common/CommentList.asp"
    comment_list_url_template = URITemplate.new("#{comment_list_url}{?#{query_params.keys.join(',')}}")
    comment_list_url_template.expand(query_params)
  end
end