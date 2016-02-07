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
        format.html { render :edit }
        format.js { render 'answers/edit', status: 200 }
      end
    else
      flash[:error] = "You can't edit the answer. You are not the owner."
      respond_to do |format|
        format.html { redirect_to @question }
        format.js { render 'answers/update', status: 401 }
      end
    end
  end

  def update
    if current_user.author_of?(@answer)
      # тут пока канкан-а нет без вложенности кажется никак
      if @answer.update(answer_params)
        flash[:success] = 'Answer successfully updated'

        respond_to do |format|
          format.html { redirect_to @question }
          format.js
        end
      else
        flash[:error] = 'Answer not updated'

        respond_to do |format|
          format.html { render :edit }
          format.js { render 'answers/edit', status: 400 }
        end
      end
    else
      flash[:error] = "You can't update the answer. You are not the owner."

      redirect_to @question
    end
  end

  def set_best
    if current_user.author_of?(@question)
      if @answer.best_answer
        @answer.update(best_answer: false)
      else
        @question.answers.update_all(best_answer: false)
        @answer.update(best_answer: true)
      end

      respond_to do |format|
        format.html { redirect_to @question }
        format.js { render 'answers/set_best', status: 200 }
      end
    else
      flash[:error] = "You can't choose best answer. You are not the owner of the question."

      redirect_to @question
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:success] = 'Answer successfully deleted'

      respond_to do |format|
        format.html { redirect_to @question }
        format.js { render 'answers/destroy', status: 200 }
      end
    else
      flash[:error] = "You can't delete the answer. You are not the owner."

      respond_to do |format|
        format.html { redirect_to @question }
        format.js { render 'answers/destroy', status: 401 }
      end
    end

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
