# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  include Voted

  def index
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
      PrivatePub.publish_to "/questions", question: @question.to_json
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
      else
        flash[:error] = 'Question is not updated'
        render :edit
      end
    else
      flash[:error] = "You can't update the question. You are not the owner."
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

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def load_question
    # @question = Question.find(params[:id])
    @question = Question.includes(:attachments, :comments, answers: [:attachments, :user, :comments]).find(params[:id])
  end

end
