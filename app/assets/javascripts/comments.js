var ready;

ready = function() {
  var userId = $('#current_user_meta').data('userId');
  var questionId = $('#answers').data('questionId');

  
  function addCommentToCommentable(data){
    var comment = $.parseJSON(data['comment']);
    var parentType = comment.relationships.commentable.commentable_type
    var parentId = comment.relationships.commentable.commentable_id
    var authorId = comment.relationships.author.author_id
    var CommentsDiv = $('#'+parentType+'_'+parentId+'_comments');
    authorId == userId ? comment.currentUserIsAuthor = true : comment.currentUserIsAuthor = false;

    newCommentDiv = JST["templates/comments/comment"]({object: comment});
    CommentsDiv.find('.'+parentType+'_comments').prepend(newCommentDiv);
    CommentsDiv.find('.commentMessages').html('');
    if (comment.currentUserIsAuthor) {
      $('.'+parentType+'_'+parentId+'_comment_content').val('');
      setTimeout(function(){
        $('.flash-messages > .alert').fadeOut('slow', function(){
          $(this).remove();
        });
      }, 3500);
      return $('.flash-messages').append(JST["templates/shared/msg"]({
        object: comment
      }));
    }
  }


  function removeCommentFromCommentable(data){
    var comment = $.parseJSON(data['comment']);
    var parentType = comment.relationships.commentable.commentable_type
    var authorId = comment.relationships.author.author_id
    authorId == userId ? comment.currentUserIsAuthor = true : comment.currentUserIsAuthor = false;

    $('#'+parentType+'_comment_'+comment.id).fadeOut('fast', function(){
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
  }

  // question comment create
  PrivatePub.subscribe('/questions/' + questionId + '/comments/create', function(data, channel) {
    return addCommentToCommentable(data);
  });


  // question comment destroy
  PrivatePub.subscribe('/questions/' + questionId + '/comments/destroy', function(data, channel) {
    return removeCommentFromCommentable(data);
  });


  // ERROR handlers
  function showCommentValidationErrors(data, bindedElement) {
    var comment = $.parseJSON(data);
    var errorsDiv = JST["templates/shared/errors"]({object: comment});

    bindedElement.find('.commentMessages').html(errorsDiv);

    return $('.flash-messages').append(JST["templates/shared/msg"]({
      object: comment
    }));
  }


  $(function() {
    $('.new_comment_form_for_question, .new_comment_form_for_answer').bind('ajax:error', function(e, xhr, status, error) {
      return showCommentValidationErrors(xhr.responseText, $(this));
    });
  });


  // If needed
  //
  // $(function() {
  //   return $('.delete_answer_comment').bind('ajax:error', function(e, xhr, status, error) {
  //     var comment;
  //     comment = $.parseJSON(xhr.responseText);
  //
  //     return $('.flash-messages').append(JST["templates/shared/msg"]({
  //       object: comment
  //     }));
  //   });
  // });

};

$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);