# Ability to vote for something
module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_vote, :already_voted, only: [:upvote, :downvote, :unvote]
    after_action :discard_flash, only: [:upvote, :downvote, :unvote]
    authorize_resource
  end


  def upvote
    current_user.vote_for(@votable, 1)
    render_response
  end

  def downvote
    current_user.vote_for(@votable, -1)
    render_response
  end

  def unvote
    current_user.unvote_for(@votable)
    render_response
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_vote
    @votable = model_klass.find(params[:id])
    instance_variable_set("@#{controller_name.singularize}", @votable)
  end

  def already_voted
    if current_user.voted_for?(@votable)
      if action_name == 'unvote'
        flash[:success] = 'Your vote has been deleted. You can re-vote now'
      else
        flash[:error] = 'You already voted for this ' + model_klass.to_s
        render_response
      end
    else
      if action_name == 'unvote'
        flash[:error] = "You didn't yet vote for #{model_klass}. There is nothing to reset"
        render_response
      else
        flash[:success] = 'You have successfully voted for ' + model_klass.to_s
      end
    end
  end

  def render_response
    render partial: 'votes/vote.json.jbuilder', locals: { votable: @votable }
  end

  def discard_flash
    flash.discard
  end

end
