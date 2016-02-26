module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_vote, only: [:upvote, :downvote, :unvote]
  end


  def upvote
    if current_user.author_of?(@votable)
      flash[:error] = "You can't vote for your own answer"
    else
      flash[:success] = 'You have successfully voted up for answer'
      current_user.vote_for(@votable, 1)
    end

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

end
