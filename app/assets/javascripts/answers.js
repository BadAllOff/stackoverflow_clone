$(document).on('click', '.cancel_update', function(e) {
  e.preventDefault();
  var answerId = $(this).data('answerId');

  $('.form_for_answer-' + answerId).hide();
  $('li#answer-'+ answerId).find('.btn-answer-edit').show();
});

var ready;

ready = function() {
    var userId;
    var questionId;
    var csrfToken = $("meta[name='csrf-token']").attr('content');

    userId = $('#current_user_meta').data('userId');
    questionId = $('#answers').data('questionId');
  
    $(function() {
        $('.vote_unvote, .vote_up, .vote_down').unbind().bind('ajax:success', function(e, data, status, xhr) {
          var votable;

          votable = $.parseJSON(xhr.responseText);

          console.log("class = "+votable.relationships.votable.classname);

          $("#"+votable.relationships.votable.classname+"-" + votable.id + " .votes_"+votable.relationships.votable.classname).html(JST["templates/votes"]({
              object: votable
          }));

          console.log(votable);

          remove_alerts();

          return $('.flash-messages').append(JST["templates/shared/msg"]({
              object: votable
          }));
        });
    });

    $(function() {
        return $('#new_answer').unbind().bind('ajax:error', function(e, data, status, xhr) {
            if (e.target.id == "new_answer") {
                var answer;
                var answerMessages = $('.answer-messages').first();
                var errorsDiv;

                answerMessages.empty();
                answer = $.parseJSON(data.responseText);

                errorsDiv = JST["templates/shared/errors"]({object: answer});
                answerMessages.prepend(errorsDiv);

                remove_alerts();

                return $('.flash-messages').append(JST["templates/shared/msg"]({
                    object: answer
                }));
            }
        });
    });

    $(function() {
        return $('.edit_answer').unbind().bind('ajax:error', function(e, data, status, xhr) {
            var answer_id;
            var answer;
            var answerMessages = $(this).find('.answer-messages');
            var errorsDiv;

            answer_id = $(this).find('.btn-info').data('answerId');
            answerMessages.empty();
            answer = $.parseJSON(data.responseText);

            errorsDiv = JST["templates/shared/errors"]({object: answer});
            answerMessages.prepend(errorsDiv);
            remove_alerts();

            return $('.flash-messages').append(JST["templates/shared/msg"]({
                object: answer
            }));
        });
    });


    function show_edit_answer_form() {
        $('.btn-answer-edit').unbind().bind('click', function(e) {
            var answer_id;
            e.preventDefault();
            answer_id = $(this).data('answerId');
            $(this).hide();
            return $('div.form_for_answer-' + answer_id).show();
        });
    }
    show_edit_answer_form();

    PrivatePub.subscribe('/questions/' + questionId + '/answers', function(data, channel) {

          var answer;
          var newAnswerDiv;
          var updatedAnswerDiv;
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


          if (answer.is_new) {
              newAnswerDiv = JST["templates/answers/answer"]({object: answer});
              $('.answers').find('ul.answers_list').prepend(newAnswerDiv);

              remove_alerts();

              if (!answer.currentUserIsAuthor){
                  answer.msgs.ok_msg = null;
                  answer.msgs.notice = " New answer was added";
              }
          }else{
              updatedAnswerDiv = JST["templates/answers/answer"]({object: answer});
              var liAnswerId = $('li#answer-'+answer.id);
              liAnswerId.replaceWith(updatedAnswerDiv);

              if (!answer.currentUserIsAuthor){
                  answer.msgs.ok_msg = null;
                  answer.msgs.notice = " Answer was updated";
                  $('li#answer-'+answer.id).find('.answer-body').addClass('bg-info');
              }
          }

          return $('.flash-messages').append(JST["templates/shared/msg"]({
              object: answer
          }));
      });
};

$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);
