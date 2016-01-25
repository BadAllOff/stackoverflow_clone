class QuestionsController < ApplicationController

  before_action :load_question, only: [:show, :edit, :update, :destroy]

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
    @question.destroy
    flash[:success] = 'Question successfully deleted'
    redirect_to questions_path
  end

  private

  def load_question

    @question = Question.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Question is not found'
    redirect_to questions_path

  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
