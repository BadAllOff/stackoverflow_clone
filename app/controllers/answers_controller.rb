class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :set_best]
  before_action :build_answer, only: [:create]
  before_action :load_answer, except: [:create]
  after_action  :subscribe_author, only: [:create, :update]

  include Voted

  respond_to :js, :json

  authorize_resource

  def create
    @answer.save ? publish_answer : render_errors
  end

  def update
    @answer.update(answer_params) ? publish_answer : render_errors
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def set_best
    @answer.set_best
    flash[:success] = 'Answer successfully set as best.'
  end

  private

  def build_answer
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
  end

  def publish_answer
    PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: render {template "#{action_name}.json.jbuilder"}
  end

  def render_errors
    render 'errors.json.jbuilder', status: 400
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.includes(:attachments, :votes, :comments, :user).find(params[:id])
    @question = @answer.question
  end

  def subscribe_author
    current_user.subscribe_to(@question)
  end
end
