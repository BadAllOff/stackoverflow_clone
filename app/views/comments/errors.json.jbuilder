json.extract! @comment, :id
json.obj_name               'Comment'

json.msgs do
  json.error_msg              flash['error']

  json.full_messages  @comment.errors.full_messages do |message|
    json.message              message
  end

end
