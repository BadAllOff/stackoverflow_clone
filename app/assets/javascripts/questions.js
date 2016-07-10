var ready;

ready = function() {
  var userId;
  var questionId;
  userId = $('#current_user_meta').data('userId');
  questionId = $('#answers').data('questionId');


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
      return $('.flash-messages').append(JST["templates/shared/msg"]({
        object: question
      }));
    });
  });

  $(function() {
    return $('.new_comment_form_for_Question').bind('ajax:error', function(e, xhr, status, error) {
      var comment;
      comment = $.parseJSON(xhr.responseText);

      errorsDiv = JST["templates/shared/errors"]({object: comment});
      $(this).find('.commentMessages').html(errorsDiv);

      return $('.flash-messages').append(JST["templates/shared/msg"]({
        object: comment
      }));
    });
  });

  $(function() {
    return $('.delete_question_comment').bind('ajax:error', function(e, xhr, status, error) {
      var comment;
      comment = $.parseJSON(xhr.responseText);

      return $('.flash-messages').append(JST["templates/shared/msg"]({
        object: comment
      }));
    });
  });

};





$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);
