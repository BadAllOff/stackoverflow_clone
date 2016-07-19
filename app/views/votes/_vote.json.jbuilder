json.extract! votable, :id

json.vote do
  json.upvotes          votable.votes.upvotes.count
  json.downvotes        votable.votes.downvotes.count
  json.rating           votable.votes.rating
  json.voted            current_user.voted_for? votable
  json.upvote_url       upvote_answer_path(votable)
  json.downvote_url     downvote_answer_path(votable)
  json.unvote_url       unvote_answer_path(votable)
end

json.msgs do
  json.error_msg        flash['error']
  json.ok_msg           flash['success']
end

json.relationships do
  json.votable do
    json.classname      votable.class.name.downcase
  end
end