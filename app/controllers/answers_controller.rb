class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :set_best]
  before_action :load_answer, except: [:create]
  include Voted
  authorize_resource

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

      if @answer.save
        current_user.subscribe_to(@question)
        flash_success('created')
        PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: render {template 'create.json.jbuilder'}
      else
        flash[:error] = 'Answer not created. Please correct your input'
        render 'errors.json.jbuilder', status: 400
      end
  end

  def update
      if @answer.update(answer_params)
        flash_success('updated')
        PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: render {template 'update.json.jbuilder'}
      else
        flash[:error] = 'Answer not updated'
        render 'errors.json.jbuilder', status: 400
      end
  end

  def destroy
    @answer.destroy
    flash_success('destroyed')
  end

  def set_best
    @answer.set_best
    flash_success('set as best')
  end

  private

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

  def flash_success(action_performed)
    flash[:success] = "Answer successfully #{action_performed}"
  end

end
