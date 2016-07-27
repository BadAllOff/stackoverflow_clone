require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user)          { create(:user) }
  let(:question)      { create(:question, user: user) }
  let(:comment)       { create(:comment, commentable: question, user: user ) }
  let(:another_user)  { create :user }


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

        it_behaves_like 'Publishable' do
          let(:channel) { "/questions/#{question.id}/comments/create" }
          let(:object) { post :create, comment: attributes_for(:comment), question_id: question, format: :json }
        end
      end

      context 'with invalid attributes' do
        it '- does not save the comment' do
          expect{ post :create, comment: attributes_for(:invalid_comment), question_id: question, format: :json }.to_not change(Comment, :count)
        end
        it '- returns errors in json format' do
          post :create, comment: attributes_for(:invalid_comment), question_id: question, format: :json
          expect(response).to render_template 'comments/errors.json.jbuilder'
          expect(response.status).to eq 400
        end
      end
    end

    context 'Non-authenticated user try to create answer' do
      it '- sends back status unauthorized' do
        expect{ post :create, comment: attributes_for(:comment), question_id: question, format: :json }.to_not change(Comment, :count)
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      sign_in_user
      context 'operates with his own comment' do
        let!(:comment) { create(:comment, commentable: question, user: @user) }
        before { comment }

        it '- deletes his own comment' do
          expect{ delete :destroy, id: comment, format: :json }.to change(Comment, :count).by(-1)
        end

        it '- gets status ok to comment view' do
          delete :destroy, id: comment, format: :json
          expect(response.status).to eq 200
        end

        it_behaves_like 'Publishable' do
          let(:channel) { "/questions/#{question.id}/comments/destroy" }
          let(:object) { delete :destroy, id: comment, format: :json }
        end
      end

      context 'operates with other user comment' do
        sign_in_another_user
        let!(:comment) { create(:comment, commentable: question, user: another_user) }

        it "- can't delete comment" do
          expect { delete :destroy, id: comment, format: :json }.to_not change(Comment, :count)
        end

      end

    end

    context 'Non-authenticated user' do
      before { comment }

      it '- fails to delete question' do
        expect{ delete :destroy, id: comment, format: :json }.to_not change(Comment, :count)
      end

      it '- redirects to sign in page' do
        delete :destroy, id: comment
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
