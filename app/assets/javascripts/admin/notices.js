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

  option_selecter($('#notice_type').val());

  $('.notice-type-option').change(function() {
      option_selecter($(this).val());
  });
});

function option_selecter(val) {
  switch(val){
    case 'external':
      $('#external-option').fadeIn('fast');
      $('#to-option').fadeOut('fast');
      break;
    case 'plain':
      $('#external-option').fadeOut('fast');
      $('#to-option').fadeOut('fast');
      break;
    case 'survey':
      $('#external-option').fadeOut('fast');
      $('#to-option').fadeOut('fast');
      break;
    case 'to':
      $('#external-option').fadeOut('fast');
      $('#to-option').fadeIn('fast');
      break;
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

function update_check_status(notice_id, response_id, check, index) {

  var url = '/admin/notices/' + notice_id + '/responses/update_check?response_id=' + response_id + "&check=" + check
  if(check == "memo") url = url + "&memo=" + $('#memo_edit_' + index).val();

  $.getJSON(url)
    .done(function (res) {
      if(check == "absence") {
        if(res.absence == 1) $('#absence_btn_' + index).addClass("btn-success");
        else $('#absence_btn_' + index).removeClass("btn-success");
      }
      else if(check == "dues") {
        if(res.dues == 1) $('#dues_btn_' + index).addClass("btn-primary");
        else $('#dues_btn_' + index).removeClass("btn-primary");
      }
      else {
        if(res.memo != "") {
          $('#memo_btn_' + index).addClass("btn-warning");
          $('#memo_div_' + index).html(res.memo);

          $('#memo_in_' + index).addClass("show_memo").removeClass("hide_memo");
          $('#memo_not_in_' + index).addClass("hide_memo").removeClass("show_memo");
        }
        else {
          $('#memo_btn_' + index).removeClass("btn-warning");

          $('#memo_not_in_' + index).addClass("hide_memo").removeClass("show_memo");
          $('#memo_in_' + index).addClass("hide_memo").removeClass("show_memo");
        }
        $('#memo_edit_' + index).val("");
      }
      
    })
    .fail(function (res) {
      
    });
}

function edit_memo(notice_id, response_id, check, index) {
  $('#memo_not_in_' + index).addClass("show_memo").removeClass("hide_memo");
  $('#memo_in_' + index).addClass("hide_memo").removeClass("show_memo");

  $('#memo_edit_' + index).val($('#memo_div_' + index).html());
}

function open_memo(index) {
  if($('#memo_in_' + index).hasClass("hide_memo")) $('#memo_not_in_' + index).addClass("show_memo").removeClass("hide_memo");
}


