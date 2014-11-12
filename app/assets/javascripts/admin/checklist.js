$(document).on('ready page:load', function () {
  userModal.init();
  checklist.init();
  assigneeComment.init();
});

var userModal = {
  target: null,
  user: null,

  init: function(){
    this.alreadySelected();

    $('.all-users-modal').on('shown.bs.modal', function (e) {
      this.target = e.relatedTarget;
    }.bind(this));

    $(".clickable-row td:not(.menu)").on("click", function(e) {
      var tr = $(this).parent();
      var user = {username: $(tr).children('.user-username').text().trim(),
                  phone_number: $(tr).children('.user-phone-number').text().trim()};

      $('.all-users-modal').modal('hide');

      userModal.getUserModel(user);
    });
  },

  alreadySelected: function(){
    $('.assignee-user_id').each(function(){
      if($(this).val()){
        userModal.getUserModel({id: $(this).val()}, $(this).siblings('.assign-btn'));
      }
    });
  },

  getUserModel: function(user, target){
    current_club = $("#current-club-slug").val()
    $.ajax({
      url: '/' + current_club + "/admin/users/get_user",
      data: {id: user.id, phone_number: user.phone_number},
      cache: false
    }).success(function(response) {
      var userModel = $.parseJSON(response);
      this.user = userModel;
      target = target || $(this.target);

      $(target).text(this.user.username);
      $(target).siblings('.assignee-user_id').val(this.user.id);
      $(target).removeClass("btn-warning").addClass('btn-success');
    }.bind(this));
  }
}

var checklist = {
  init: function(){
    this.hideUnusedInput();
    this.showAtLeastOne();

    $('.checklist-form').keyup(function(e){
      this.hideUnusedInput();
      this.showAtLeastOne();
    }.bind(this));
  },

  showAtLeastOne: function(){
    if ($('.checklist-form').css('display') == 'none') {
      $('.checklist-form').first().show();
    }
  },

  hideUnusedInput: function(){
    $('.checklist-form input[type="text"]').each(function(index){
      form = $(this).parents('.checklist-form');
      prevInput = form.prev().find('input[type="text"]').val();

      if($(this).val() == ""  && prevInput == "")
        form.hide();

      if($(this).val().length >= 1)
        form.next().fadeIn('fast');
    });
  }
}

var assigneeComment = {
  init: function(){
    $('.comment-value').click(this.setEditableComment);
  },

  setEditableComment: function(e){
    if($(this).parents().hasClass('list-group-item-warning')){
      $('.new-comment-form').hide();
      $('.comment-form').each(function(){
        $(this).hide().prev().show();
      });
      $(e.target).hide().next().css('display','table');
    }
  }
}

