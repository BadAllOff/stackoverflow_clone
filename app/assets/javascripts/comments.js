var ready;

ready = function() {

  var userId;
  var questionId;
  userId = $('#current_user_meta').data('userId');
  questionId = $('#answers').data('questionId');

  // question comment create
  PrivatePub.subscribe('/questions/' + questionId + '/comments/create', function(data, channel) {
    var comment;
    comment = $.parseJSON(data['comment']);
    comment.author.author_id == userId ? comment.currentUserIsAuthor = true : comment.currentUserIsAuthor = false;

    $('.new_comment_form_for_Question').find('.commentMessages').html('');

    newCommentDiv = JST["templates/comments/comment"]({object: comment});
    $('.question_comments').append(newCommentDiv);

    if (comment.currentUserIsAuthor) {
      $('.Question_'+comment.parent_id+'_comment_content').val('');

      setTimeout(function(){
        $('.flash-messages > .alert').fadeOut('slow', function(){
          $(this).remove();
        });
      }, 3500);

      return $('.flash-messages').append(JST["templates/shared/msg"]({
        object: comment
      }));
    }

  });
  // question comment destroy
  PrivatePub.subscribe('/questions/' + questionId + '/comments/destroy', function(data, channel) {

    var comment;
    comment = $.parseJSON(data['comment']);
    comment.author.author_id == userId ? comment.currentUserIsAuthor = true : comment.currentUserIsAuthor = false;

    $('.question_comments').find('#'+comment.parent_type+'_comment_'+comment.id).fadeOut('fast', function(){
      $(this).remove();
    });

    if (comment.currentUserIsAuthor) {

      setTimeout(function(){
        $('.flash-messages > .alert').fadeOut('slow', function(){
          $(this).remove();
        });
      }, 3500);

      return $('.flash-messages').append(JST["templates/shared/msg"]({
        object: comment
      }));
    }
  });

  // answer comment create
  PrivatePub.subscribe('/answers/' + questionId + '/comments/create', function(data, channel) {
    var comment;
    comment = $.parseJSON(data['comment']);
    comment.author.author_id == userId ? comment.currentUserIsAuthor = true : comment.currentUserIsAuthor = false;

    newCommentDiv = JST["templates/comments/comment"]({object: comment});
    $("#answer_"+comment.parent_id+"_comments").find('.answer_comments').prepend(newCommentDiv);
    $("#answer_"+comment.parent_id+"_comments").find('.commentMessages').html('');

    if (comment.currentUserIsAuthor) {
      $('.Answer_'+comment.parent_id+'_comment_content').val('');

      return $('.flash-messages').append(JST["templates/shared/msg"]({
        object: comment
      }));
    }


  });
  // answer comment destroy
  PrivatePub.subscribe('/answers/' + questionId + '/comments/destroy', function(data, channel) {

    var comment;
    comment = $.parseJSON(data['comment']);
    comment.author.author_id == userId ? comment.currentUserIsAuthor = true : comment.currentUserIsAuthor = false;

    $('#'+comment.parent_type+'_comment_'+comment.id).fadeOut('fast', function(){
      $(this).remove();
    });

    if (comment.currentUserIsAuthor) {

      setTimeout(function(){
        $('.flash-messages > .alert').fadeOut('slow', function(){
          $(this).remove();
        });
      }, 3500);

      return $('.flash-messages').append(JST["templates/shared/msg"]({
        object: comment
      }));
    }
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);