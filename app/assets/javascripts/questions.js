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
  }, 2500);

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
    return $('.delete_question_comment').bind('ajax:error', function(e, xhr, status, error) {
      var comment;
      comment = $.parseJSON(xhr.responseText);

      return $('.flash-messages').append(JST["templates/shared/msg"]({
        object: comment
      }));
    });
  });

  PrivatePub.subscribe("/questions", function(data, channel) {
    var question;
    question = $.parseJSON(data.question);
    cUr = $.parseJSON(data.current_user);

    question.user_id == userId ? question.currentUserIsAuthor = true : question.currentUserIsAuthor = false;
    newQuestionDiv = JST["templates/questions/new_question"]({object: question});
    $('.questions_list').prepend(newQuestionDiv);
  });

};





$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);
