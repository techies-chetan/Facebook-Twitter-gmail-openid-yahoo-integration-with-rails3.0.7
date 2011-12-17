// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
  $('#logout').click(function(e) {
    FB.logout(function(response) {
    var url = $('#logout').attr('redirect_url');
    $.ajax({
      url: url,
      type: 'DELETE',
      success: function(msg) {
        window.location = '/';
        }
      });
    });
    e.preventDefault();
  });
});

