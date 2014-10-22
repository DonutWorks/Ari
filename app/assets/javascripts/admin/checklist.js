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
    });

    $('.all-users-modal').on('hidden.bs.modal', function (e) {
      $(this.target).text(user_modal.user.username);
      $(this.target).siblings('.assignee-phone-number').val(user_modal.user.phone_number);
      $(this.target).siblings('.assignee-username').val(user_modal.user.username);
      $(this.target).removeClass("btn-warning").addClass('btn-success');
    });

    $(".clickable-row td:not(.menu)").on("click", function(e) {
      var tr = $(this).parent();
      var user = {username: $(tr).children('.user-username').text().trim(),
                  phone_number: $(tr).children('.user-phone-number').text().trim()};
      user_modal.user = user;

      $('.all-users-modal').modal('hide');
    });
  },

  already_selected: function(){
    $('.assignee-phone-number').each(function(){
      if($(this).val() != ""){
        td = $('.user-phone-number:contains("' + $(this).val() + '")');
        name = $(td).siblings('.user-username').text();
        $(this).siblings('.assign-btn').text(name);
        $(this).siblings('.assign-btn').removeClass("btn-warning").addClass('btn-success');
      }
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
      assignee = form.find('input[type="hidden"]').val();

      prev_input = form.prev().find('input[type="text"]').val();
      
      if($(this).val() == ""  && prev_input == "" && assignee == "")
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

