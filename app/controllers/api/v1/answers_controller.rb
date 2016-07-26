class Api::V1::AnswersController < Api::V1::BaseController
  respond_to :json
  before_action :set_question, only: [:index, :show, :create]

  def index
    respond_with @question.answers, each_serializer: AnswerCollectionSerializer
  end

  def show
    respond_with @question.answers.find(params[:id])
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

end