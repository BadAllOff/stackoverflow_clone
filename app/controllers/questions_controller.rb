class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
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
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      flash[:success] = 'Question successfully created'
      redirect_to @question
    else
      flash[:error] = 'Question is not created'
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      if @question.update(question_params)
        flash[:success] = 'Question successfully updated'

        respond_to do |format|
          format.html { redirect_to @question }
          format.js
        end
      else
        flash[:error] = 'Question is not updated'

        respond_to do |format|
          format.html { render :edit }
          format.js { render 'questions/update', status: 400}
        end
      end
    else
      flash[:error] = "You can't update the question. You are not the owner."
      redirect_to @question
    end
  end

  def destroy
    if current_user.author_of?(@question)
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

end
