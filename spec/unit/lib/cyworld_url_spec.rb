require "rails_helper"

RSpec.describe CyworldURL do
  describe "#expanded_url" do
    it "should expand shorten url" do
      url = CyworldURL.new("http://club.cyworld.com/1234567812/123456789")
      expect(url.to_comment_view_url).to eq("http://club.cyworld.com/club/board/common/CommentList.asp?club_id=12345678&board_type=1&board_no=2&item_seq=123456789")
    end

    it "should expand board_no correctly" do
      url = CyworldURL.new("http://club.cyworld.com/12345678123/123456789")
      expect(url.to_comment_view_url).to eq("http://club.cyworld.com/club/board/common/CommentList.asp?club_id=12345678&board_type=1&board_no=23&item_seq=123456789")
    end

    it "should fail for invalid url" do
      url = CyworldURL.new("http://www.google.com")
      expect { url.to_comment_view_url }.to raise_error

      url = CyworldURL.new("http://club.cyworld.com/123/123/123")
      expect { url.to_comment_view_url }.to raise_error

      url = CyworldURL.new("http://club.cyworld.com/asd/asd")
      expect { url.to_comment_view_url }.to raise_error
    end
  end
end