class ExcelBuilder
  def self.build_excel_file(comments, habitat_format_header)
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    invalid_format = Spreadsheet::Format.new :color => :red,
                                 :weight => :bold
    habitat_club = Club.friendly.find('snu-habitat')

    if !habitat_format_header

      comments.first.keys.each_with_index do |key, index|
        sheet1.row(0).push(key.to_s) if index > 0
      end

      comments.each_with_index do |comment, index_out|
        invalid = false
        comment.values.each_with_index do |value, index_in|
          if index_in == 0
            invalid = value
          else
            sheet1.row(index_out+1).default_format = invalid_format if invalid
            sheet1.row(index_out+1).push(value)
          end
        end
      end

    else

      habitat_format_header.keys.each_with_index do |key, index|
        sheet1.row(0).push(key.to_s)
      end


      comments.each_with_index do |comment, index_out|
        invalid = false
        notfound = false

        #Now, only can find by username and last four digits of phone_number
        username = comment[:이름]
        phone_number_last = comment[:"핸드폰 번호 뒷자리"]


        invalid = comment[comment.keys[0]]
        invalid = true if username.blank? || phone_number_last.blank?
        if !invalid
          comment_user = habitat_club.users.where("username = ? AND phone_number LIKE ?", username, "%#{phone_number_last}").first
          notfound = true if !comment_user
        end

        if invalid
          sheet1.row(index_out+1).default_format = invalid_format
          sheet1.row(index_out+1).push(comment[comment.keys[1]])
        elsif notfound
          sheet1.row(index_out+1).default_format = invalid_format
          comment.keys[1..-1].each do |key|
            sheet1.row(index_out+1).push(comment[key])
          end
        else
          habitat_format_header.each do |key, value|
            sheet1.row(index_out+1).push(comment_user[value.to_sym]||"")
          end

        end

      end
    end

    bookstring = StringIO.new
    book.write bookstring
    return bookstring.string
  end
end
