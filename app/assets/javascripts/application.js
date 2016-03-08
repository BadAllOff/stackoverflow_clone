// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require peek
//= require peek/views/performance_bar
//= require peek/views/rblineprof
//= require jquery.remotipart
//= require turbolinks
//= require bootstrap
//= require cocoon
//= require jquery-ui
//= require_tree .

var ready;

ready = function() {
    setTimeout(function(){
        $('.flash-messages > .alert').fadeOut('slow', function(){
            //$(this).remove();
        });
    }, 5500);

  $(function() {
    return $('#answers').bind('ajax:success', function(e, data, status, xhr) {
      var answer;
      answer = $.parseJSON(xhr.responseText);
      $("#answer-" + answer.id + " .votes_answer").html(JST["templates/votes"]({
        object: answer
      }));
      return $('.flash-messages').append(JST["templates/msg"]({
        object: answer
      }));
    });
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);
