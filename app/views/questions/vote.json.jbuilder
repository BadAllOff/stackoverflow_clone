json.extract! @question, :id

json.vote do
  json.upvotes          @question.votes.upvotes.count
  json.downvotes        @question.votes.downvotes.count
  json.rating           @question.votes.rating
  json.voted            current_user.voted_for? @question
  json.upvote_url       upvote_question_path(@question)
  json.downvote_url     downvote_question_path(@question)
  json.unvote_url       unvote_question_path(@question)
end

json.msgs do
  json.error_msg        flash['error']
  json.ok_msg           flash['success']
end

json.relationships do
  json.votable do
    json.classname          @question.class.name.downcase
  end
end