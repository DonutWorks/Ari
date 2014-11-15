$(document).on('ready page:load', function(){
  recordModal.init();

  $('.record-delete-btn').width($('.record-modal').width());
});

var recordModal = {
  record: null,

  init: function(){
    $('#record-select-modal').on('click', '.clickable-row', function(e){
      response = $(e.target).parent().data('response')
      bank_account = $(e.target).parent().data('bank-account-id')

      current_club = $("#current-club-slug").val()
      $.ajax({
        url : '/' + current_club + '/admin/bank_accounts/'+bank_account+'/expense_records/' + this.record + '/submit_dues',
        data: {response_id: response, record_id: record},
        cache: false
      }).success(function(){
        location.reload();
      });
    });

    $('tbody').on('click', '.record-modal', this.saveRecord);
  },

  saveRecord: function(e){
    this.record = $(e.target).data('record')
  }.bind(this)
}