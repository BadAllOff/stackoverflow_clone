var ready;

ready = function() {
  var userId;
  var questionId;
  userId = $('#current_user_meta').data('userId');
  questionId = $('#answers').data('questionId');

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

  $('form#edit_question_'+questionId).data('remote', 'true');

};





$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);
