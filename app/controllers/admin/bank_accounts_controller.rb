class Admin::BankAccountsController < Admin::ApplicationController
  def download_account_example
    send_file(
      "#{Rails.root}/public/account_example.xlsx",
      filename: "account_example.xlsx",
      type: "application/xlsx")
  end
end