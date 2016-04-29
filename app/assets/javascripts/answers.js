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

  $(function() {
    return $('#new_answer').unbind().bind('ajax:success', function(e, data, status, xhr) {
      var answer;
      var newAnswerDiv;

      answer = $.parseJSON(xhr.responseText);
      answer.currentUserId = userId;
      newAnswerDiv = JST["templates/answer"]({ object: answer});
      console.log(newAnswerDiv);
      console.log(answer);
      $('.answers').find('ul.answers_list').prepend(newAnswerDiv);
      return $('.flash-messages').append(JST["templates/msg"]({
        object: answer
      }));
    });
  });



  PrivatePub.subscribe('/questions/' + questionId + '/answers', function(data, channel) {
    return console.log(data, questionId, userId);
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);
