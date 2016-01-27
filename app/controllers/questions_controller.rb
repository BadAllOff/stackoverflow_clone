class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id

    if @question.save
      flash[:success] = 'Question successfully created'
      redirect_to @question
    else
      flash[:error] = 'Question not created'
      render :new
    end
  end

  def update
    if @question.update(question_params)
      flash[:success] = 'Question successfully updated'
      redirect_to @question
    else
      flash[:error] = 'Question not updated'
      render :edit
    end
  end

  def destroy
    if @question.user_id == current_user.id
      @question.destroy
      flash[:success] = 'Your question successfully deleted.'
      redirect_to questions_path
    else
      flash[:error] = 'You cant delete this question. You are not the owner.'
      redirect_to @question
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def record_not_found
    flash[:error] = 'Record not found'
    redirect_to questions_path
  end
end
