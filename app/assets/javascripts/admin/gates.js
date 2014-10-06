$(document).on('ready page:load', function () {

  $('.sms-text').width($('.container').width());
  $('.notice-full-page').css('margin-bottom', $('.sms-text').height()+ 20);

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

    $('#phone_numbers').text("총 " + phone_numbers_cnt + "명이 선택 되었습니다.");
  }

});

