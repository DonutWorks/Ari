$(document).on("ready page:load", function () {
  $("#remember-me").on("change", function (e) {
    kakao_sign_in_link = $("#kakao-login-btn").attr("href");
    checked = $(this).prop("checked")? "1" : "0";
    if(kakao_sign_in_link.indexOf("&remember_me=") < 0) {
      kakao_sign_in_link += ("&remember_me=" + checked);
    } else {
      kakao_sign_in_link = kakao_sign_in_link.replace(/&remember_me=[01]/, "&remember_me=" + checked);
    }
    $("#kakao-login-btn").attr("href", kakao_sign_in_link);
  });
});