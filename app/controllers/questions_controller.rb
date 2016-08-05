class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy, :subscribe, :unsubscribe]
  before_action :set_subscription, only: [:subscribe, :unsubscribe]
  include Voted
  authorize_resource

  def index
    @questions = Question.includes(:user).all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      set_subscription
      PrivatePub.publish_to '/questions', question: @question.to_json
      flash[:success] = 'Question successfully created'
      redirect_to @question
    else
      flash[:error] = 'Question is not created'
      render :new
    end
  end

  def update
    if @question.update(question_params)
      flash[:success] = 'Question successfully updated'
    else
      flash[:error] = 'Question is not updated'
      render :edit
    end
  end

  def destroy
    @question.destroy
    flash[:success] = 'Your question successfully deleted.'
    redirect_to questions_path
  end

  def subscribe
    flash[:success] = 'You are successfully subscribed'
    redirect_to @question
  end

  def unsubscribe
    @subscription.delete if @subscription
    flash[:success] = 'You are successfully unsubscribed'
    redirect_to @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def load_question
    @question = Question.includes(comments: [:user], attachments: [:attachable], answers: [:attachments, :user, comments: [:user]]).find(params[:id])
  end

  def set_subscription
    @subscription = Subscription.find_or_create_by(user: current_user, question: @question)
  end

end
