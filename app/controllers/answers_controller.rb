class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :edit, :set_best]
  before_action :load_answer, except: [:create]
  include Voted

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:success] = 'Answer successfully created'
    else
      flash[:error] = 'Answer not created. Please correct your input'
    end
  end

  def edit
  end

  def update
    if current_user.author_of?(@answer)
      if @answer.update(answer_params)
        flash[:success] = 'Answer successfully updated'
      else
        flash[:error] = 'Answer not updated'
        render :edit
      end
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:success] = 'Answer successfully deleted'
    else
      flash[:error] = "You can't delete the answer. You are not the owner of this answer."
    end
  end

  def set_best
    if current_user.author_of?(@question)
      @answer.set_best
      flash[:success] = 'Success'
    else
      flash[:error] = "You can't choose best answer. You are not the owner of this question."
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.includes(:attachments, :votes).find(params[:id])
    @question = @answer.question
  end

end
