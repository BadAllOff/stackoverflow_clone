class AnswersController < ApplicationController
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :load_question
  before_action :load_answer, except: [:create]

  def create
    @answer = @question.answers.create(answer_params)
    if @answer.errors.any?
      flash[:error] = 'Answer not created'
    else
      flash[:success] = 'Answer successfully created'
    end
    redirect_to @question
  end

  def destroy
    if @question.answers.destroy(@answer)
      flash[:success] = 'Answer successfully destroyed'
    else
      flash[:error] = 'Answer is not destroyed'
    end
    redirect_to @question
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

  def record_not_found
    flash[:error] = 'Record not found'
    redirect_to @question
  end

end
