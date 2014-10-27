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

  $('.memo-edit').keypress(function(event){
    if(event.keyCode == 13){
      event.preventDefault();
      $('#memo_button').click();
    }
  });

  $('#fee-checkbox').change(function() {
   $('#fee-option').toggle(this.checked);
  });
});

function optionSelector(val) {
  switch(val) {
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

function updateCheckStatus(notice_id, response_id, check, index) {

  var url = '/admin/notices/' + notice_id + '/responses/update_check?response_id=' + response_id + "&check=" + check
  if(check == "memo") url = url + "&memo=" + $('#memo-edit-' + index).val();

  $.getJSON(url)
    .done(function (res) {
      if(check == "absence") {
        if(res.absence == 1) $('#absence-btn-' + index).addClass("btn-success");
        else $('#absence-btn-' + index).removeClass("btn-success");
      }
      else if(check == "dues") {
        if(res.dues == 1) $('#dues-btn-' + index).addClass("btn-primary");
        else $('#dues-btn-' + index).removeClass("btn-primary");
      }
      else {
        if(res.memo != "") {
          $('#memo-btn-' + index).addClass("btn-warning");
          $('#memo-content-' + index).html(res.memo);

          $('#memo-in-' + index).addClass("show-memo").removeClass("hide-memo");
          $('#memo-not-in-' + index).addClass("hide-memo").removeClass("show-memo");
        }
        else {
          $('#memo-btn-' + index).removeClass("btn-warning");

          $('#memo-not-in-' + index).addClass("hide-memo").removeClass("show-memo");
          $('#memo-in-' + index).addClass("hide-memo").removeClass("show-memo");
        }
        $('#memo-edit-' + index).val("");
      }

    })
    .fail(function (res) {

    });
}

function editMemo(notice_id, response_id, check, index) {
  $('#memo-not-in-' + index).addClass("show-memo").removeClass("hide-memo");
  $('#memo-in-' + index).addClass("hide-memo").removeClass("show-memo");

  $('#memo-edit-' + index).val($('#memo-content-' + index).html());
}

function openMemo(index) {
  if($('#memo-in-' + index).hasClass("hide-memo")) $('#memo-not-in-' + index).addClass("show-memo").removeClass("hide-memo");
}