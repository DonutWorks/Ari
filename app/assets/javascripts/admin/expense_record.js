$(document).on('ready page:load', function(){
  recordModal.init();  
});

var recordModal = {
  record: null,

  init: function(){
    $('#record-select-modal').on('click', '.clickable-row', function(e){
      response = $(e.target).parent().data('response')

      $.ajax({
        url : '/admin/expense_records/' + this.record + '/submit_dues',
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