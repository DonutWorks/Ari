
$(document).on('ready page:load', function () {
  $('#tags2').textcomplete([
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

  $('#user_filter_word2').textcomplete([
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

  function split( val ) {
    return val.split( /,\s*/ );
  }
  function extractLast( term ) {
    return split( term ).pop();
  }

  $( "#user_filter_word" ).autocomplete({
    source: function( request, response ) {
      current_club = $("#current-club-slug").val()

      $.getJSON('/' + current_club + '/admin/users/search/' + request.term )
      .done(function (res) {

        $("#table-user-list").find("tr:gt(0)").css("display","none");

        for (var i in res) {
          var user = res[i];
          $("#tr-user-id-" + user.id).css("display","");
        }

      })
      .fail(function (res) {

      });

    },
    minLength: 0

  });

  $('#tags').bind( "keydown", function( event ) {
    if ( event.keyCode === $.ui.keyCode.TAB &&
        $( this ).autocomplete( "instance" ).menu.active ) {
      event.preventDefault();
    }
  })
  .autocomplete({
    source: function( request, response ) {
      current_club = $("#current-club-slug").val()

      $.getJSON( '/' + current_club + '/admin/users/tags/' + extractLast( request.term )
      , response );
    },
    search: function() {
      // custom minLength
      var term = extractLast( this.value );
      if ( term.length < 0 ) {
        return false;
      }
    },
    focus: function() {
      // prevent value inserted on focus
      return false;
    },
    select: function( event, ui ) {
      var terms = split( this.value );
      // remove the current input
      terms.pop();
      // add the selected item
      terms.push( ui.item.value );
      // add placeholder to get the comma-and-space at the end
      terms.push( "" );
      this.value = terms.join( ", " );
      return false;
    }
  });


});
