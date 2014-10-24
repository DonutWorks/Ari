$(document).on('ready page:load', function () {
  user_modal.init();
  checklist.init();
  assignee_comment.init();
});

var user_modal = {
  target: null,
  user: null,

  init: function(){
    this.already_selected();

    $('.all-users-modal').on('shown.bs.modal', function (e) {
      this.target = e.relatedTarget;
    }.bind(this));

    $(".clickable-row td:not(.menu)").on("click", function(e) {
      var tr = $(this).parent();
      var user = {username: $(tr).children('.user-username').text().trim(),
                  phone_number: $(tr).children('.user-phone-number').text().trim()};

      $('.all-users-modal').modal('hide');

      user_modal.get_user_model_on_ajax(user);
    });
  },

  already_selected: function(){
    $('.assignee-user_id').each(function(){
      if($(this).val()){
        user_modal.get_user_model_on_ajax({id: $(this).val()}, $(this).siblings('.assign-btn'));
      }
    });
  },

  get_user_model_on_ajax: function(user, target){
    $.ajax({
      url: "/admin/users/get_user",
      data: {id: user.id, phone_number: user.phone_number},
      cache: false
    }).success(function(response) {
      var user_model = $.parseJSON(response);
      this.user = user_model;
      target = target || $(this.target); 

      $(target).text(this.user.username);
      $(target).siblings('.assignee-user_id').val(this.user.id);
      $(target).removeClass("btn-warning").addClass('btn-success');
    }.bind(this));
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
      prev_input = form.prev().find('input[type="text"]').val();

      if($(this).val() == ""  && prev_input == "")
        form.hide();

      if($(this).val().length >= 1)
        form.next().fadeIn('fast');
    });
  }
}

var assignee_comment = {
  init: function(){
    $('.comment-value').click(this.editable_comment);
  },

  editable_comment: function(e){
    if($(this).parents().hasClass('list-group-item-warning')){
      $('.new-comment-form').hide();
      $('.comment-form').each(function(){
        $(this).hide().prev().show();
      });
      $(e.target).hide().next().css('display','table');
    }
  }
}

