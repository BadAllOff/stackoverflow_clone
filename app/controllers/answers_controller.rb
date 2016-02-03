class AnswersController < ApplicationController
  before_action :authenticate_user!

  before_action :load_question
  before_action :load_answer, except: [:create]

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
    if current_user.author_of?(@answer)
      respond_to do |format|
        format.html do
          render :edit
        end

        format.js do
        end

      end
    else
      flash[:error] = "You can't edit the answer. You are not the owner."
      redirect_to @question
    end
  end

  def update
    if current_user.author_of?(@answer)
      # тут пока канкан-а нет без вложенности кажется никак
      if @answer.update(answer_params)
        flash[:success] = 'Answer successfully updated'
        respond_to do |format|
          format.html do
            redirect_to @question
          end

          format.js do
          end
        end

      else
        flash[:error] = 'Answer not updated'
        respond_to do |format|
          format.html do
            render :edit
          end

          format.js do
            render :'answers/update', status: 400
          end
        end

      end
    else
      flash[:error] = "You can't update the answer. You are not the owner."
      redirect_to @question
    end
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
