require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
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

  describe 'DELETE #destroy' do
    before { answer }
    it 'deletes answer' do
      expect { delete :destroy, question_id: question, id: answer  }.to change(Answer, :count).by(-1)
    end

    it 'redirect to question view' do
      delete :destroy, question_id: question, id: answer
      expect(response).to redirect_to question_path(question)
    end
  end
end
