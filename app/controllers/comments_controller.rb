class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  before_action :load_comment, only: :destroy
  after_action  :discard_flash

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.json do
          flash[:success] = 'Comment successfully created'
          if @comment.commentable_type == 'Question'
            PrivatePub.publish_to "/questions/#{@comment.commentable_id}/comments/create", comment: render {template 'create.json.jbuilder'}
          end
          if @comment.commentable_type == 'Answer'
            PrivatePub.publish_to "/answers/#{@comment.commentable.question_id}/comments/create", comment: render {template 'create.json.jbuilder'}
          end
        end
      else
        format.json do
          flash['error'] = 'Please, check your input and try again'
          render 'errors.json.jbuilder', status: 400
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      if @comment.user == current_user
        @comment.destroy
        format.json do
          flash['success'] = 'Comment deleted'
          if @comment.commentable_type == 'Question'
            PrivatePub.publish_to "/questions/#{@comment.commentable_id}/comments/destroy", comment: render {template 'destroy.json.jbuilder'}
          end
          if @comment.commentable_type == 'Answer'
            PrivatePub.publish_to "/answers/#{@comment.commentable.question_id}/comments/destroy", comment: render {template 'destroy.json.jbuilder'}
          end
        end
      else
        format.json do
          flash['error'] = "You can't delete the comment. You are not the owner."
          render 'errors.json.jbuilder', status: 400
        end
      end
    end

  end

  private

  def set_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentable_name = $1
        @commentable = $1.classify.constantize.find(value)
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