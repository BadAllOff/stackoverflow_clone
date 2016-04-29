json.extract! @answer, :id

json.author do
  json.author_id @answer.user_id
  json.author_name @answer.user_id
end

json.vote do
  json.upvotes @answer.votes.upvotes.count
  json.downvotes @answer.votes.downvotes.count
  json.rating @answer.votes.rating
  json.voted current_user.voted_for? @answer
  json.upvote_url upvote_answer_path(@answer)
  json.downvote_url downvote_answer_path(@answer)
  json.unvote_url unvote_answer_path(@answer)
end

json.msgs do
  json.error_msg flash['error']
  json.ok_msg flash['success']
end

json.attachments @answer.attachments do |attachment|
  json.filename attachment.filename
  json.url url_for(attachment)
end