class AnswersController < ApplicationController
  before_action :authenticate_user!

  before_action :load_question
  before_action :load_answer, except: [:create]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save

    if @answer.errors.any?
      flash[:error] = 'Answer not created. Please correct your input'
    else
      flash[:success] = 'Answer successfully created'
    end

    redirect_to @question
  end

  def destroy
    if current_user.author_of?(@answer)
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

end
