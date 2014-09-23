class CyworldURL
  def initialize(shorten_url)
    @shorten_url = shorten_url
  end

  def to_comment_view_url
    shorten_url_template = URITemplate.new("http://club.cyworld.com{/segments*}")
    extracts = shorten_url_template.extract(@shorten_url)

    raise "주소가 유효하지 않습니다. 다시 한번 확인해주세요." unless valid_extracts?(extracts)

    params = extracts["segments"]
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

private
  def valid_extracts?(extracts)
    if extracts.blank? or extracts["segments"].length != 2
      false
    else
      extracts["segments"][0] !~ /\D/ and extracts["segments"][1] !~ /\D/
    end
  end
end