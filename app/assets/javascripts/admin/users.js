
$(document).on('ready page:load', function () {
  $('#tags').textcomplete([
    {
      match: /\B#([^\s]*)$/,
      search: function (term, callback) {
        current_club = $("#current-club-slug").val()
        $.getJSON('/' + current_club + '/admin/users/tags/' + term)
        .done(function (res) {
          callback($.map(res, function (tag) {
            return '#' + tag.tag_name + " ";
          }));
        })
        .fail(function (res) {
          callback([]);
        });
      },
      replace: function (tag) {
        return tag + ' ';
      },
      index: 1
    }]);

  $("textarea.shift-enter").keydown(function(e){

    if (e.keyCode == 13 && !e.shiftKey)
    {
        if (this.form)
          this.form.submit();
        else
          e.preventDefault();
        return false;
    }

  });

  $('#user_filter_word').textcomplete([
    {
      match: /(.*)$/,
      search: function (term, callback) {
        current_club = $("#current-club-slug").val()
        $.getJSON('/' + current_club + '/admin/users/search/' + term)
        // $.getJSON('/admin/users/search/' + term)
        .done(function (res) {

          $("#table-user-list").find("tr:gt(0)").css("display","none");

          for (var i in res) {
            var user = res[i];
            $("#tr-user-id-" + user.id).css("display","");
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
