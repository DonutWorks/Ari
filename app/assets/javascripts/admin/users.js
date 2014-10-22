
$(document).on('ready page:load', function () {
  $('#tags').textcomplete([
    {
      match: /\B#([^\s]*)$/,
      search: function (term, callback) {
        $.getJSON('/admin/users/tags/' + term)
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

  $('#user_filter_word').textcomplete([
    {
      match: /(.*)$/,
      search: function (term, callback) {
        $.getJSON('/admin/users/search/' + term)
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
