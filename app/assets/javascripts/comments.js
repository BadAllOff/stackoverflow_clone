var ready;

ready = function() {

  var userId;
  var questionId;
  userId = $('#current_user_meta').data('userId');
  questionId = $('#answers').data('questionId');



  //TODO pub\sub

// create question comment
  PrivatePub.subscribe('/questions/' + questionId + '/comments/create', function(data, channel) {
    var comment;
    comment = $.parseJSON(data['comment']);

    $('.new_comment_form_for_Question').find('.commentMessages').html('');

    if (comment.author.author_id == userId) {
      comment.currentUserIsAuthor = true;
    }else{
      comment.currentUserIsAuthor = false;
    }

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

  PrivatePub.subscribe('/questions/' + questionId + '/comments/destroy', function(data, channel) {
    
    var comment;
    comment = $.parseJSON(data['comment']);

    if (comment.author.author_id == userId) {
      comment.currentUserIsAuthor = true;
    }else{
      comment.currentUserIsAuthor = false;
    }

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

// create answer comment
  PrivatePub.subscribe('/answers/' + questionId + '/comments/create', function(data, channel) {
    comment = $.parseJSON(data['comment']);
    return alert(comment);z

    newCommentDiv = JST["templates/comments/comment"]({object: comment});
    $(this).find('.commentMessages').html('');
    $(this)[0].reset();

    $("#answer_"+comment.parent_id+"_comments").append(newCommentDiv);

    if (comment.author.author_id == userId) {
      comment.currentUserIsAuthor = true;
      $('#answer_body').val('');
    }else{
      comment.currentUserIsAuthor = false;
    }

    return $('.flash-messages').append(JST["templates/shared/msg"]({
      object: comment
    }));

  });

};


$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);