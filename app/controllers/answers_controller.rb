class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :set_best]
  before_action :load_answer, except: [:create]
  include Voted
  authorize_resource

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    respond_to do |format|
      if @answer.save
        set_subscription
        format.json do
          flash[:success] = 'Answer successfully created'
          PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: render {template 'create.json.jbuilder'}
        end
      else
        format.json do
          flash[:error] = 'Answer not created. Please correct your input'
          render 'errors.json.jbuilder', status: 400
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.json do
          flash[:success] = 'Answer successfully updated'
          PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: render {template 'update.json.jbuilder'}
        end
      else
        format.json do
          flash[:error] = 'Answer not updated'
          render 'errors.json.jbuilder', status: 400
        end
      end
    end
  end

  def destroy
    @answer.destroy
    flash[:success] = 'Answer successfully deleted'
  end

  def set_best
    @answer.set_best
    flash[:success] = 'Success'
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

  def set_subscription
    @subscription = Subscription.find_or_create_by(user: current_user, question: @question)
  end

end
