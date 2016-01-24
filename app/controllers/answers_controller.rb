class AnswersController < ApplicationController
  before_action :load_question, only: [:create]
  before_action :load_answer, except: [:create]

  def create
    @answer = @question.answers.create(answer_params)
    if @answer.errors.any?
      flash[:error] = 'Answer not created'
    else
      flash[:success] = 'Answer successfully created'
    end
    redirect_to question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

end
