$(document).on('ready page:load', function () {
  user_modal.init();
  checklist.init();
});

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

var checklist = {
  init: function(){
    this.hide_unused_input();
    this.show_at_least();

    $('.checklist-form').keyup(function(e){
      this.hide_unused_input();
      this.show_at_least();
    }.bind(this));
  },

  show_at_least: function(){
    if ($('.checklist-form').css('display') == 'none') {
      $('.checklist-form').first().show();
    }
  },

  hide_unused_input: function(){
    $('.checklist-form input[type="text"]').each(function(index){
      form = $(this).parents('.checklist-form');
      phone = form.find('input[type="hidden"]').val();

      prev_input = form.prev().find('input[type="text"]').val();
      
      if($(this).val() == ""  && prev_input == "" && phone == "nil")
        form.hide();

      if($(this).val().length >= 1)
        form.next().fadeIn('fast');
    });
  }
}

