json.extract! @comment, :id

json.created_at @comment.created_at.strftime('%H:%M:%S %Y-%m-%d %Z')

json.author do
  json.author_id @comment.user_id
  json.author_name @comment.user.username
end

json.msgs do
  json.error_msg flash['error']
  json.ok_msg flash['success']
end

json.content @comment.content