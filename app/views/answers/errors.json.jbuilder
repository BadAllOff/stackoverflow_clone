json.extract! @answer, :id
json.obj_name               'Answer'

json.msgs do
  json.error_msg              flash['error']

  json.full_messages  @answer.errors.full_messages do |message|
    json.message              message
  end

end
