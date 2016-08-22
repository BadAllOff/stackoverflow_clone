class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  include Voted
  include Subscribed
  authorize_resource

  def index
    return @questions = Question.includes(:user).all if user_signed_in?
    @questions = Question.all
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
      current_user.subscribe_to(@question)
      PrivatePub.publish_to '/questions', question: @question.to_json
      flash_success('created')
      redirect_to @question
    else
      flash[:error] = 'Question is not created'
      render :new
    end
  end

  def update
    if @question.update(question_params)
      flash_success('updated')
    else
      flash[:error] = 'Question is not updated'
      render :edit
    end
  end

  def destroy
    @question.destroy
    flash_success('deleted')
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def load_question
    if user_signed_in?
      @question = Question.includes(comments: [:user], attachments: [:attachable], answers: [:attachments, :user, comments: [:user]]).find(params[:id])
    else
      @question = Question.includes(:comments, attachments: [:attachable], answers: [:attachments, :user, :comments]).find(params[:id])
    end
  end

  def flash_success(action_performed)
    flash[:success] = "Question successfully #{action_performed}"
  end

end
