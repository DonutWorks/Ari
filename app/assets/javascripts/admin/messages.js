$(document).on('ready page:load', function () {


  $('.sms_all_searched').change(function() {
    var id = (this).id.replace('_all_searched','');

    $('.' + id + '.found').prop("checked", this.checked);

    add_phone_number_to_array();
  });


  $('.sms_check').change(function() {
    add_phone_number_to_array();
  });

  $('#sms_content').keyup(change_sms_text_size);


  $('#search_word').textcomplete([
    {
      match: /(.*)$/,
      search: function (term, callback) {
        current_club = $("#current-club-slug").val()
        $.getJSON('/' + current_club + '/admin/users/search/' + term)
        .done(function (res) {

          $("#table-receiver").find("tr:gt(0)").css("display","none");
          $("#table-receiver").find(".sms.found").removeClass('found');

          for (var i in res) {
            var user = res[i];
            $("#tr-user-id-" + user.id).css("display","");
            $("#tr-user-id-" + user.id).find(".sms").addClass('found');
          }

          callback([]);
        })
        .fail(function (res) {
          callback([]);
        });
      },
      replace: function (user) {
        return user;
      },
      index: 1
    }]);
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

