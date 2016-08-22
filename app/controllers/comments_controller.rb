class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  before_action :load_comment, only: :destroy
  after_action  :discard_flash
  authorize_resource

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

      if @comment.save
        flash[:success] = 'Comment successfully created'
        PrivatePub.publish_to set_chanel(@comment, 'create'), comment: render {template 'create.json.jbuilder'}
      else
        flash['error'] = 'Please, check your input and try again'
        render 'errors.json.jbuilder', status: 400
      end
  end

  def destroy
    @comment.destroy
    flash['success'] = 'Comment deleted'
    PrivatePub.publish_to set_chanel(@comment, 'destroy'), comment: render {template 'destroy.json.jbuilder'}
  end

  private

  def set_chanel(comment, method)
    if comment.commentable_type == 'Question'
      "/questions/#{@comment.commentable_id}/comments/#{method}"
    elsif comment.commentable_type == 'Answer'
      "/questions/#{@comment.commentable.question_id}/comments/#{method}"
    end
  end

  def set_commentable
    params.each do |name, value|
      if name =~ /(question|answer)_id$/
        @commentable_name = Regexp.last_match(1)
        @commentable = @commentable_name.classify.constantize.find(value)
      end
    end
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def discard_flash
    flash.discard
  end
end
