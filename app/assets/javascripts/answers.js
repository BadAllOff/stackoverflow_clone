var ready;

ready = function() {
  setTimeout(function(){
    $('.flash-messages > .alert').fadeOut('slow', function(){
      $(this).remove();
    });
  }, 3500);

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
