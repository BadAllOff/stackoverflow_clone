json.extract! @answer, :id

json.is_new                   false
json.parentQuestionId         @answer.question.id
json.parentQuestionAuthorId   @answer.question.user.id
json.body                     @answer.body
json.created_at               @answer.created_at
json.updated_at               @answer.updated_at

json.author do
  json.author_id              @answer.user_id
  json.author_name            @answer.user.username
end

json.vote do
  json.upvotes                @answer.votes.upvotes.count
  json.downvotes              @answer.votes.downvotes.count
  json.rating                 @answer.votes.rating
  json.voted                  current_user.voted_for? @answer
  json.upvote_url             upvote_answer_path(@answer)
  json.downvote_url           downvote_answer_path(@answer)
  json.unvote_url             unvote_answer_path(@answer)
end

json.msgs do
  json.error_msg              flash['error']
  json.ok_msg                 flash['success']
end

json.attachments @answer.attachments do |attachment|
  json.id                     attachment.id
  json.filename               attachment.file.filename
  json.url                    attachment.file.url
end