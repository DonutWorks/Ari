$(document).on('ready page:load', function () {
  if($('.notice-type-option:checked').val() != "to")
    $('#to-option').hide();

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

  $('.notice-type-option').change(function() {
    switch($(this).val()){
      case 'plain':
         $("#notice_link").attr("disabled",true);
        break;
      case 'survey':
        $("#notice_link").attr("disabled",true);
        break;
      case 'to':
        $('#to-option').fadeIn('fast');
        $("#notice_link").attr("disabled",true);
        break;
      default:
        $("#notice_link").attr("disabled",false);
        $('#to-option').fadeOut('fast');
    }
  });
});

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
