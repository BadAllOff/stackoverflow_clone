class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show
  after_action  :publish_question, only: :create
  after_action  :subscribe_author, only: [:create, :update]

  include Voted
  include Subscribed

  respond_to :js, :json

  authorize_resource

  def index
    respond_with(@questions = Question.includes(:user).all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def load_question
    @question = Question.includes(comments: [:user], attachments: [:attachable], answers: [:attachments, :user, comments: [:user]]).find(params[:id])
  end

  def publish_question
    PrivatePub.publish_to '/questions', question: @question.to_json
  end

  def subscribe_author
    current_user.subscribe_to(@question)
  end

  def build_answer
    @answer = @question.answers.build
  end

end
