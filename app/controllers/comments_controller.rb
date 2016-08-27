class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  before_action :build_comment, only: :create
  before_action :load_comment, only: :destroy
  after_action  :discard_flash

  respond_to :json

  authorize_resource

  def create
    @comment.save ? publish_comment : render_errors
  end

  def destroy
    @comment.destroy ? publish_comment : render_errors
  end

  private

  def build_comment
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
  end

  def publish_comment
    PrivatePub.publish_to set_chanel(@comment, "#{action_name}"), comment: render {template "#{action_name}.json.jbuilder"}
  end

  def render_errors
    render 'errors.json.jbuilder', status: 400
  end

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
