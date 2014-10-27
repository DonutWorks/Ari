class Admin::ExpenseRecordsController < Admin::ApplicationController
  def index
    @account = Account.find_by_account_number("110383537755")
  end

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

        flash[:notice] = "최신 내역으로 업데이트 되었습니다."
        redirect_to admin_account_expense_records_path(@account)
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