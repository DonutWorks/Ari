$(document).on('ready page:load', function () {
  $('.selectpicker').selectpicker();

  $('.sms_all').change(function() {
    var id = (this).id.replace('_all','');

    $('.' + id).prop("checked", this.checked);

    add_phone_number_to_array();
  });


  $('.sms_check').change(function() {
    add_phone_number_to_array();
  });

  $('#sms_content').keyup(change_sms_text_size);

  option_selecter($('#notice_type').val());

  $('.notice-type-option').change(function() {
      option_selecter($(this).val());
  });

  user_modal.init();  
});

function option_selecter(val) {
  switch(val){
    case 'external':
      $('#external-option').fadeIn('fast');
      $('#to-option').fadeOut('fast');
      $('#checklist-option').fadeOut('fast');
      break;
    case 'plain':
      $('#external-option').fadeOut('fast');
      $('#to-option').fadeOut('fast');
      $('#checklist-option').fadeOut('fast');
      break;
    case 'survey':
      $('#external-option').fadeOut('fast');
      $('#to-option').fadeOut('fast');
      $('#checklist-option').fadeOut('fast');
      break;
    case 'to':
      $('#external-option').fadeOut('fast');
      $('#to-option').fadeIn('fast');
      $('#checklist-option').fadeOut('fast');
      break;
    case 'checklist':
      $('#external-option').fadeOut('fast');
      $('#to-option').fadeOut('fast');
      $('#checklist-option').fadeIn('fast');

  }
}

function add_phone_number_to_array() {
  var phone_numbers_cnt = 0;

  $('.sms_check').each(function() {
    if((this).checked === true) phone_numbers_cnt++;
  });

  if(phone_numbers_cnt >= 1){
    $('.notice-full-page').addClass('show-sms');
    $('.sms-text').slideDown();
    $('#phone_numbers').text("총 " + phone_numbers_cnt + "명이 선택 되었습니다.");
  }
  else if (phone_numbers_cnt == 0){
    $('.sms-text').slideUp();
    $('.notice-full-page').removeClass('show-sms');
  }
}

function change_sms_text_size(){
  var string = $('#sms_content').val();

  var utf8length = 0;

  for (var n = 0; n < string.length; n++) {
    var c = string.charCodeAt(n);
    if (c < 128) {
      utf8length++;
    }
    else {
      utf8length = utf8length+2;
    }

    if (utf8length >= 90){
      var new_str = string.substr(0,n)
      $('#sms_content').val(new_str);
      break;
    }
  }
  $('#current-text-size').text(utf8length);
}

var user_modal = {
  target: null,
  user: null,

  init: function(){
    $('.all-users-modal').on('shown.bs.modal', function (e) {
      this.target = e.relatedTarget;
    });

    $('.all-users-modal').on('hidden.bs.modal', function (e) {
      $(this.target).text(user_modal.user.name);
      $(this.target).siblings('input[type="hidden"]').val(user_modal.user.phone_number);
      $(this.target).removeClass("btn-warning").addClass('btn-success');
    });

    $(".clickable-row td:not(.menu)").on("click", function(e) {
      var tr = $(this).parent();
      var user = {name: $(tr).children('#user-name').text().trim(),
                  phone_number: $(tr).children('#user-phone-number').text().trim()};
      user_modal.user = user;
      $('.all-users-modal').modal('hide');
    });
  }
}