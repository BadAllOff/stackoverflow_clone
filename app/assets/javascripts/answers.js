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
    return $(document).bind('ajax:success', function(e, data, status, xhr) {
      if (e.target.className == "btn btn-warning vote_unvote" || e.target.className == "btn btn-info vote_up" || e.target.className == "btn btn-danger vote_down" ) {
        var answer;
        answer = $.parseJSON(xhr.responseText);
        $("#answer-" + answer.id + " .votes_answer").html(JST["templates/votes"]({
          object: answer
        }));
        return $('.flash-messages').append(JST["templates/shared/msg"]({
          object: answer
        }));
      }
    });
  });

  $(function() {
    return $('#new_answer').unbind().bind('ajax:success', function(e, data, status, xhr) {
      if (e.target.id == "new_answer" ) {
        var answer;
        var newAnswerDiv;
        var answerMessages = $('.answer-messages');

        answerMessages.empty();

        answer = $.parseJSON(xhr.responseText);
        console.log(answer);
        if (answer.author.author_id == userId) {
          answer.currentUserIsAuthor = true;
        }else{
          answer.currentUserIsAuthor = false;
        }

        if (answer.parentQuestionAuthorId == userId) {
          answer.currentUserIsAuthorOfQuestion = true;
        }else{
          answer.currentUserIsAuthorOfQuestion = false;
        }

        console.log(answer.currentUserIsAuthor);
        console.log(answer.author.author_id);
        newAnswerDiv = JST["templates/answers/answer"]({object: answer});
        $('.answers').find('ul.answers_list').prepend(newAnswerDiv);
        $('#answer_body').val('');
        return $('.flash-messages').append(JST["templates/shared/msg"]({
          object: answer
        }));
      }
    });
  });

  PrivatePub.subscribe('/questions/' + questionId + '/answers', function(data, channel) {
    return console.log(data, questionId, userId);
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);
