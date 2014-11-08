class Admin::ExpenseRecordsController < Admin::ApplicationController
  def index
    @bank_account = BankAccount.find_by_account_number("110383537755")
    @remaining_responses = find_remaining_responses
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

        @results = result_array.group_by{|h| h[:activity] }
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

  def destroy
    ExpenseRecord.find(params[:id]).destroy
    redirect_to :back
  end

  def submit_dues
    expense_record = ExpenseRecord.find(params[:record_id])
    response = Response.find(params[:response_id])

    if expense_record.response
      expense_record.response.update!(dues: 0)
      expense_record.response = nil
    end

    expense_record.response = response
    response.update!(dues: 1)

    render text: ""
  end

private
  def find_remaining_responses
    cases = []

    Notice.where(notice_type: 'to').each do |notice|
      notice.responses.each do |response|
        cases << {id: response.id, activity: notice.activity, notice: notice, response: response, user: response.user} if response.dues == 0     
      end 
    end

    cases
  end
end