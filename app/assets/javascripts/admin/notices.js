$(document).on('ready page:load', function () {
  if($('.notice-type-option:checked').val() != "to")
    $('#to-option').hide();

  $('.sms_all').change(function() {
    var id = (this).id.replace('_all','');

    $('.' + id).prop("checked", this.checked);

    add_phone_number_to_array();
  });


  $('.sms_check').change(function() {
    add_phone_number_to_array();
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

  $('.notice-type-option').change(function() {
    switch($(this).val()){
      case 'to':
        $('#to-option').fadeIn('fast');
        break;
      default:
        $('#to-option').fadeOut('fast');
    }
  });

});