class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  after_action  :discard_flash

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.json do
          flash['success'] = 'Comment added'
          render {template 'create.json.jbuilder'}
        end
      else
        format.json do
          flash['error'] = 'Please, check your input and try again'
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

  def comment_params
    params.require(:comment).permit(:content)
  end

  def discard_flash
    flash.discard
  end
end