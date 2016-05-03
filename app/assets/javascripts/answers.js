var ready;

ready = function() {
  var userId;
  var questionId;

  userId = $('#current_user_meta').data('userId');
  questionId = $('#answers').data('questionId');

  $(function() {
    return $('.votes_answer').bind('ajax:success', function(e, data, status, xhr) {
      var answer;
      answer = $.parseJSON(xhr.responseText);
      $("#answer-" + answer.id + " .votes_answer").html(JST["templates/votes"]({
        object: answer
      }));

      setTimeout(function(){
        $('.flash-messages > .alert').fadeOut('slow', function(){
          $(this).remove();
        });
      }, 3500);

      return $('.flash-messages').append(JST["templates/shared/msg"]({
        object: answer
      }));
    });
  });


  PrivatePub.subscribe('/questions/' + questionId + '/answers', function(data, channel) {

    var answer;
    var newAnswerDiv;
    var answerMessages = $('.answer-messages');

    answerMessages.empty();

    answer = $.parseJSON(data['answer']);
    if (answer.author.author_id == userId) {
      answer.currentUserIsAuthor = true;
      $('#answer_body').val('');
    }else{
      answer.currentUserIsAuthor = false;
    }

    if (answer.parentQuestionAuthorId == userId) {
      answer.currentUserIsAuthorOfQuestion = true;
    }else{
      answer.currentUserIsAuthorOfQuestion = false;
    }

    newAnswerDiv = JST["templates/answers/answer"]({object: answer});
    $('.answers').find('ul.answers_list').prepend(newAnswerDiv);

    setTimeout(function(){
      $('.flash-messages > .alert').fadeOut('slow', function(){
        $(this).remove();
      });
    }, 3500);

    if (!answer.currentUserIsAuthor){
      answer.msgs.ok_msg = null;
      answer.msgs.notice = " New answer was added";
    }

    return $('.flash-messages').append(JST["templates/shared/msg"]({
      object: answer
    }));
  });



  $(function() {
      return $('#new_answer').unbind().bind('ajax:error', function(e, data, status, xhr) {
        if (e.target.id == "new_answer" ) {
          var answer;
          var answerMessages = $('.answer-messages').first();

          answerMessages.empty();

          console.log(e);
          console.log(data);
          console.log(status);
          console.log(xhr);
          answer = $.parseJSON(data.responseText);
          console.log(answer);

          errorsDiv = JST["templates/shared/errors"]({object: answer});

          answerMessages.prepend(errorsDiv);

          setTimeout(function(){
            $('.flash-messages > .alert').fadeOut('slow', function(){
              $(this).remove();
            });
          }, 3500);

          return $('.flash-messages').append(JST["templates/shared/msg"]({
            object: answer
          }));

        }
      });
  });

  //$(function() {
  //  return $('#new_answer').unbind().bind('ajax:success', function(e, data, status, xhr) {
  //    if (e.target.id == "new_answer" ) {
  //      var answer;
  //      var newAnswerDiv;
  //      var answerMessages = $('.answer-messages');
  //
  //      answerMessages.empty();
  //
  //      answer = $.parseJSON(xhr.responseText);
  //      if (answer.author.author_id == userId) {
  //        answer.currentUserIsAuthor = true;
  //      }else{
  //        answer.currentUserIsAuthor = false;
  //      }
  //
  //      if (answer.parentQuestionAuthorId == userId) {
  //        answer.currentUserIsAuthorOfQuestion = true;
  //      }else{
  //        answer.currentUserIsAuthorOfQuestion = false;
  //      }
  //
  //      newAnswerDiv = JST["templates/answers/answer"]({object: answer});
  //      $('.answers').find('ul.answers_list').prepend(newAnswerDiv);
  //      $('#answer_body').val('');
  //
  //      setTimeout(function(){
  //        $('.flash-messages > .alert').fadeOut('slow', function(){
  //          $(this).remove();
  //        });
  //      }, 3500);
  //
  //      return $('.flash-messages').append(JST["templates/shared/msg"]({
  //        object: answer
  //      }));
  //    }
  //  });
  //});

};

$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);
