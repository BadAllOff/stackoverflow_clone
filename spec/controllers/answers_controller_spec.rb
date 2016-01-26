require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    context 'Authenticated user' do
      sign_in_user
      context 'with valid attributes' do
        it 'saves new answer in the database' do
          expect{ post :create, answer: attributes_for(:answer), question_id: question }.to change(question.answers, :count).by(1)
        end
        it 'redirect back to Question' do
          post :create, answer: attributes_for(:answer), question_id: question
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect{ post :create, answer: attributes_for(:invalid_answer), question_id: question }.to_not change(Answer, :count)
        end
        it 'redirects back to Question' do
          post :create, answer: attributes_for(:invalid_answer), question_id: question
          expect(response).to redirect_to question_path(question)
        end
      end
    end

    context 'Non-authenticated user try to create answer' do
      it 'redirects to login page' do
        expect{ post :create, answer: attributes_for(:answer), question_id: question }.to_not change(question.answers, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      sign_in_user
      before { answer }
      it 'deletes answer' do
        expect { delete :destroy, question_id: question, id: answer  }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question view' do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Non-authenticated user try to delete answer' do
      before { answer }
      it 'redirects to login page' do
        expect { delete :destroy, question_id: question, id: answer  }.to_not change(Answer, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
