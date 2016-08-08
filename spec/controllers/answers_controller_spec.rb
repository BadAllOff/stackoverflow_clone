require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user)          { create(:user) }
  let(:question)      { create(:question, user: user) }
  let(:answer)        { create(:answer, question: question, user: user) }
  let(:another_user)  { create :user }

  describe 'POST #create' do

    context 'Non-authenticated user try to create answer' do
      it '- unauthorized to create answer' do
        expect{ post :create, answer: attributes_for(:answer), question_id: question, format: :json }.to_not change(question.answers, :count)
        expect(response.status).to eq 401
      end
    end

    context 'Authenticated user' do
      sign_in_user
      context 'with valid attributes' do
        it '- saves new answer in the DB with correct user identification' do
          expect{ post :create, answer: attributes_for(:answer), question_id: question, format: :json }.to change(@user.answers, :count).by(1)
        end

        it '- saves new answer in the DB with correct question identification' do
          expect{ post :create, answer: attributes_for(:answer), question_id: question, format: :json }.to change(question.answers, :count).by(1)
        end

        it '- subscribes author to question' do
          expect { post :create, answer: attributes_for(:answer), question_id: question, format: :json }.to change(@user.subscriptions, :count).by(1)
        end

        it '- creates subscription to question' do
          expect { post :create, answer: attributes_for(:answer), question_id: question, format: :json }.to change(question.subscriptions, :count).by(1)
        end

        it '- returns OK status' do
          post :create, answer: attributes_for(:answer), question_id: question, format: :json
          expect(response.status).to eq 200
        end

        it_behaves_like 'Publishable' do
          let(:channel) { "/questions/#{question.id}/answers" }
          let(:object) { post :create, answer: attributes_for(:answer), question_id: question, format: :json }
        end
      end

      context 'with invalid attributes' do
        it '- does not save the answer' do
          expect{ post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :json }.to_not change(Answer, :count)
        end
        it '- when not valid' do
          post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :json
          expect(response).to render_template 'answers/errors.json.jbuilder'
          expect(response.status).to eq 400
        end
      end
    end
  end


  describe 'PATCH #update' do

    context 'Non-authenticated' do
      it '- unauthorized to update answer' do
        patch :update, question_id: question, id: answer, answer: { body: 'I am SkyNet!' }, format: :json
        expect(response.status).to eq 401
      end
    end

    context 'Authenticated user' do
      sign_in_user
      context 'operates with his own answer' do
        let!(:answer) { create(:answer, question: question, user: @user) }
        context 'when valid' do
          it '- assigns the requested answer to @answer' do
            patch :update, question_id: question, id: answer, answer: attributes_for(:answer), format: :json
            expect(assigns(:answer)).to eq answer
          end

          it '- changes answer attributes' do
            patch :update, question_id: question, id: answer, answer: { body: 'This is updated answer' }, format: :json
            answer.reload
            expect(answer.body).to eq 'This is updated answer'
          end

          it '- sends back status ok' do
            patch :update, question_id: question, id: answer, answer: { body: 'This is updated answer' }, format: :json
            expect(response.status).to eq 200
          end
        end

        context 'when invalid' do
          before { patch :update, question_id: question, id: answer, answer: { body: nil }, format: :json }
          it '- does not change answer attributes' do
            answer.reload
            expect(answer.body).to eq 'This is the Answer body'
          end

          it '- shows errors on page' do
            expect(response).to render_template 'answers/errors.json.jbuilder'
          end
        end
      end

      context 'operates with another user answer' do
        sign_in_another_user
        let!(:answer) { create(:answer, question: question, user: @user) }
        before { patch :update, question_id: question, id: answer, answer: { body: 'This is another user answer' }, format: :json }

        it '- does not change answer attributes' do
          answer.reload
          expect(answer.body).to eq 'This is the Answer body'
        end
      end
    end

  end


  describe 'PATCH #set_best' do

    context 'Non-authenticated' do
      before { answer }
      it '- unauthorized to set best' do
        patch :set_best, id: answer, question_id: question, format: :js
        expect(response.status).to eq(401)
      end
    end

    context 'Authenticated user' do
      sign_in_user
      context 'operates with his own question answers' do
        let!(:question) { create(:question, user: @user) }
        let!(:answer) { create(:answer, question: question, user: user) }
        let!(:another_answer) { create(:answer, question: question, user: user) }

        it '- assigns the requested answer to @answer' do
          patch :set_best, question_id: question.id, id: answer, format: :js
          expect(assigns(:answer)).to eq answer
        end

        it "- set's best answer" do
          patch :set_best, question_id: question.id, id: answer, format: :js
          answer.reload
          expect(answer.best_answer).to eq true
        end

        it '- best answer can be only one' do
          patch :set_best, question_id: question.id, id: another_answer, format: :js
          answer.reload
          another_answer.reload
          expect(answer.best_answer).to eq false
          expect(another_answer.best_answer).to eq true
        end

        it '- re-renders answer set_best view' do
          patch :set_best, question_id: question.id, id: answer, format: :js
          expect(response).to render_template 'set_best'
        end
      end


      context 'operates with another users answer' do
        sign_in_another_user
        let!(:question) { create(:question, user: user) }
        let!(:answer) { create(:answer, question: question, user: user) }

        before { patch :set_best, question_id: question.id , id: answer, format: :js }

        it '- does not change answer attributes' do
          answer.reload
          expect(answer.best_answer).to eq false
        end
      end
    end

  end


  describe 'DELETE #destroy' do

    context 'Non-authenticated user' do
      before { answer }
      it '- unauthorized to delete answer' do
        expect { delete :destroy, question_id: question, id: answer, format: :js }.to_not change(Answer, :count)
        expect(response.status).to eq 401
      end
    end

    context 'Authenticated user' do
      sign_in_user
      before { answer }

      context 'operates with his own answer' do
        let!(:answer) { create(:answer, question: question, user: @user) }

        it '- deletes his own answer' do
          expect {delete :destroy, question_id: question, id: answer, format: :js }.to change(@user.answers, :count).by(-1)
        end

        it '- gets status ok to answer view' do
          delete :destroy, question_id: question, id: answer, format: :js
          expect(response.status).to eq 200
        end
      end

      context "operates with other user's answer" do
        sign_in_another_user
        let!(:answer) { create(:answer, question: question, user: @user) }

        it "- can't delete answer" do
          expect { delete :destroy, question_id: question, id: answer, format: :js }.to_not change(Answer, :count)
        end

      end
    end
  end

  # Voting

  it_behaves_like 'Votable', 'Answer' do
    let(:object) { create(:answer, question: question, user: user) }
  end

end
