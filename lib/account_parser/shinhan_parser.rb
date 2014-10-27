module AccountParser
  class ShinhanParser
    CONTENTS_START_ROW = 9
    CONTENTS_START_COLUMN = 2
    CONTENTS_END_COLUMN = 9
    CONTENTS_NAMES = [:record_date, :record_time, nil, :withdraw, :deposit, :content, nil, nil]

    def self.parse_records(file)
      attr_hashes = []

      (CONTENTS_START_ROW..file.last_row).each do |r|
        next if file.cell(r, CONTENTS_START_COLUMN).nil? || file.cell(r, CONTENTS_START_COLUMN) == "거래일자"
        attr_hash = Hash.new

        (CONTENTS_START_COLUMN..CONTENTS_END_COLUMN).each do |c|
          col = CONTENTS_NAMES.at(c - CONTENTS_START_COLUMN)
          attr_hash[col] = file.cell(r,c) || "" if col
        end

        attr_hashes.push merge_datetime(attr_hash)
      end

      return attr_hashes
    end

  private
    def self.merge_datetime(attr_hash)
      d = Date.parse(attr_hash[:record_date])
      t = Time.parse(attr_hash[:record_time])
      dt = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec)

      attr_hash[:record_date] = dt
      attr_hash.delete(:record_time)

      return attr_hash
    end
  end
end