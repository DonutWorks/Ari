class Admin::ExportExcelController < Admin::ApplicationController
    #   get 'export' => 'export_excel#get_export'
    # post 'export' => 'export_excel#export'
  def export
  end

  def export_excel
    format = params[:format]
    notice_link = params[:notice_link]
    
  end
end
