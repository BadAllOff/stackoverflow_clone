json.extract! @comment, :id
json.obj_name               'Comment'
json.parent_id    @comment.commentable_id
json.parent_type  @comment.commentable_type.downcase
json.created_at   @comment.created_at.strftime('%H:%M:%S %Y-%m-%d %Z')

json.author do
  json.author_id @comment.user_id
  json.author_name @comment.user.username
end

json.msgs do
  json.error_msg flash['error']
  json.ok_msg flash['success']
end

json.type 'comments'

json.attributes do
  json.created_at   @comment.created_at.strftime('%H:%M:%S %Y-%m-%d %Z')
  json.content      @comment.content
end

json.relationships do
  json.author do
    json.author_id @comment.user_id
    json.author_name @comment.user.username
  end

  json.commentable do
    json.commentable_type @comment.commentable_type.downcase
    json.commentable_id   @comment.commentable_id
  end
end