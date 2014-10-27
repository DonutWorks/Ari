class Admin::ExpenseRecordsController < Admin::ApplicationController
  def new
    @account = Account.find_by_account_number("110383537755")
  end

  def create
    @account = Account.find(params[:account_id])

    if !params[:upload].blank?
      file = ExcelImporter.import(params[:upload][:file])
      file.default_sheet = file.sheets.first
  
      if @account.account_number == file.cell(5, 4).delete("-")
        attr_hashes = AccountParser::ShinhanParser.parse_records(file)

        attr_hashes.each do |attr|
          er = @account.expense_records.build(attr)

          if er.valid?
            er.save!
          end
        end
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