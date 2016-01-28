class AnswersController < ApplicationController
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :load_question
  before_action :load_answer, except: [:create]

  def create

    @answer = @question.answers.build(answer_params)

    if @answer.errors.any?
      flash[:error] = 'Answer not created. Please correct your input'
    else
      @answer.user_id = current_user.id
      if @answer.save
        flash[:success] = 'Answer successfully created'
      else
        flash[:error] = 'Answer not created'
      end
    end

    redirect_to @question
  end

  def destroy
    if @answer.user_id == current_user.id
      @answer.destroy
      flash[:success] = 'Answer successfully deleted'
    else
      flash[:error] = "You can't delete the answer. You are not the owner."
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
