var ready;

ready = function() {
  setTimeout(function(){
    $('.flash-messages > .alert').fadeOut('slow', function(){
      $(this).remove();
    });
  }, 3500);

  $(function() {
    return $('#question').bind('ajax:success', function(e, data, status, xhr) {
      var question;
      question = $.parseJSON(xhr.responseText);
      $("#question-" + question.id + " .votes_question").html(JST["templates/votes"]({
        object: question
      }));
      return $('.flash-messages').append(JST["templates/msg"]({
        object: question
      }));
    });
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);
