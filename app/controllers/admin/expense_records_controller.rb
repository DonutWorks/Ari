class Admin::ExpenseRecordsController < Admin::ApplicationController
  def index
    @bank_account = BankAccount.find_by_account_number("110383537755")
  end

  def new
    @bank_account = BankAccount.find_by_account_number("110383537755")
  end

  def create
    @bank_account = BankAccount.find(params[:bank_account_id])
    result_array = []

    if !params[:upload].blank?
      file = ExcelImporter.import(params[:upload][:file])
      file.default_sheet = file.sheets.first
  
      if @bank_account.account_number == file.cell(5, 4).delete("-")
        attr_hashes = BankAccountParser::ShinhanParser.parse_records(file)

        attr_hashes.each do |attr|
          record = @bank_account.expense_records.build(attr)

          if record.valid?
            if result = record.check_dues
              result_array.push result
              record.confirm = true
            end
            record.save!
          end
        end

        @results = result_array.group_by{|h| h[:notice] }
        flash[:notice] = "회계 기록이 최신 정보로 업데이트 되었습니다."
        @results.empty? ? redirect_to(admin_bank_account_expense_records_path(@bank_account)) : render("result")
      else
        flash[:error] = "동아리 계좌가 아닙니다. 관리자에게 문의하세요."
        redirect_to :back
      end

    else
      flash[:error] = "첨부파일을 업로드하세요."
      redirect_to :back
    end
  end
end