$(document).on('ready page:load', function () {
  $('.selectpicker').selectpicker();

  $('.sms_all').change(function() {
    var id = (this).id.replace('_all','');

    $('.' + id).prop("checked", this.checked);

    addPhoneNumberToArray();
  });


  $('.sms_check').change(function() {
    addPhoneNumberToArray();
  });

  $('#sms_content').keyup(changeSMSTextSize);

  optionSelector($('.notice-type-option:checked').val());

  $('.notice-type-option').change(function() {
      optionSelector($(this).val());
  });
});

function optionSelector(val) {
  switch(val){
    case 'external':
      $('#external-option').show();
      $('#to-option').hide();
      $('#checklist-option').hide();
      break;
    case 'plain':
      $('#external-option').hide();
      $('#to-option').hide();
      $('#checklist-option').hide();
      break;
    case 'survey':
      $('#external-option').hide();
      $('#to-option').hide();
      $('#checklist-option').hide();
      break;
    case 'to':
      $('#external-option').hide();
      $('#to-option').show();
      $('#checklist-option').hide();
      break;
    case 'checklist':
      $('#external-option').hide();
      $('#to-option').hide();
      $('#checklist-option').show();
      break;
  }
}

function addPhoneNumberToArray() {
  var phoneNumbersCnt = 0;

  $('.sms_check').each(function() {
    if((this).checked === true) phoneNumbersCnt++;
  });

  if(phoneNumbersCnt >= 1){
    $('.notice-full-page').addClass('show-sms');
    $('.sms-text').slideDown();
    $('#phone_numbers').text("총 " + phoneNumbersCnt + "명이 선택 되었습니다.");
  }
  else if (phoneNumbersCnt == 0){
    $('.sms-text').slideUp();
    $('.notice-full-page').removeClass('show-sms');
  }
}

function changeSMSTextSize(){
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