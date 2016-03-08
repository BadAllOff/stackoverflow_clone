# Ability to vote for something
module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_vote, only: [:upvote, :downvote, :unvote]
  end

  def upvote
    if current_user.author_of?(@votable)
      flash[:error] = "You can't vote for your own #{model_klass}"
    else
      if current_user.voted_for?(@votable)
        flash[:error] = 'You already voted up for this ' + model_klass.to_s
      else
        flash[:success] = 'You have successfully voted up for ' + model_klass.to_s
        current_user.vote_for(@votable, 1)
      end
    end

    update_rating

    render 'vote'
  end

  def downvote
    if current_user.author_of?(@votable)
      flash[:error] = "You can't vote for your own #{model_klass}"
    else
      if current_user.voted_for?(@votable)
        flash[:error] = 'You already voted down for this ' + model_klass.to_s
      else
        flash[:success] = 'You have successfully voted down for ' + model_klass.to_s
        current_user.vote_for(@votable, -1)
      end
    end

    update_rating

    render 'vote'
  end

  def unvote
    if current_user.author_of?(@votable)
      flash[:error] = "You can't vote for your own " + model_klass.to_s
    else
      if current_user.voted_for?(@votable)
        flash[:success] = 'Your vote has been deleted. You can re-vote now'
        current_user.unvote_for(@votable)
      else
        flash[:error] = "You didn't yet vote for #{model_klass}. There is nothing to reset"
      end
    end

    update_rating

    render 'vote'
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_vote
    @votable = model_klass.find(params[:id])
    instance_variable_set("@#{controller_name.singularize}", @votable)
  end

  def update_rating
    @votable.rating(@votable.votes.rating)
  end

end
