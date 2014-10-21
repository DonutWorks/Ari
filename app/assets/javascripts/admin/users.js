
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
});
