require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user)      { create(:user) }
  let!(:question)  { create(:question, user: user) }
  let!(:comment)   { create(:comment, commentable: question, user: user ) }

  describe 'POST #create' do
    context 'Authenticated user' do
      sign_in_user
      context 'with valid attributes' do

        it '- saves new comment in the DB with correct question identification' do
          expect{ post :create, comment: attributes_for(:comment), question_id: question, format: :json }.to change(question.comments, :count).by(1)
        end

        it '- saves new comment in the DB with correct user identification' do
          expect{ post :create, comment: attributes_for(:comment), question_id: question, format: :json }.to change(@user.comments, :count).by(1)
        end

        it '- returns OK status' do
          post :create, comment: attributes_for(:comment), question_id: question, format: :json
          expect(response.status).to eq 200
        end
      end

      context 'with invalid attributes' do
        it '- does not save the answer' do
          expect{ post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :json }.to_not change(Answer, :count)
        end
        it '- returns errors in json format' do
          post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :json
          expect(response).to render_template 'answers/errors.json.jbuilder'
          expect(response.status).to eq 400
        end
      end
    end

    context 'Non-authenticated user try to create answer' do
      it '- sends back status unauthorized' do
        expect{ post :create, answer: attributes_for(:answer), question_id: question, format: :json }.to_not change(question.answers, :count)
        expect(response.status).to eq 401
      end
    end
  end

end
