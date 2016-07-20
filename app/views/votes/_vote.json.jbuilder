json.extract! votable, :id

json.vote do
  json.upvotes          votable.votes.upvotes.count
  json.downvotes        votable.votes.downvotes.count
  json.rating           votable.votes.rating
  json.voted            current_user.voted_for? votable
  json.upvote_url       send("upvote_#{votable.class.name.downcase}_path", votable)
  json.downvote_url     send("downvote_#{votable.class.name.downcase}_path", votable)
  json.unvote_url       send("unvote_#{votable.class.name.downcase}_path", votable)
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