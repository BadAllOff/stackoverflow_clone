require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    context 'Authenticated user' do
      sign_in_user
      context 'with valid attributes' do
        it 'saves new answer in the DB with correct user identification' do
          expect{ post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(@user.answers, :count).by(1)
        end

        it 'saves new answer in the DB with correct question identification' do
          expect{ post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(question.answers, :count).by(1)
        end

        it 'renders create partial' do
          post :create, answer: attributes_for(:answer), question_id: question, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect{ post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }.to_not change(Answer, :count)
        end
        it 'renders create partial' do
          post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'Non-authenticated user try to create answer' do
      it 'sends back status unauthorized' do
        expect{ post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to_not change(question.answers, :count)
        expect(response.status).to eq 401
      end
    end
  end

  describe 'GET #edit' do
    context 'Authenticated user' do
      sign_in_user

      let!(:answer) { create(:answer, question: question, user: @user) }
      before { get :edit, question_id: question, id: answer, format: :js}

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'Non-authenticated user try to edit answer' do
      before { answer }
      it 'sends back status unauthorized' do
        get :edit, question_id: question, id: answer, format: :js
        expect(response.status).to eq(401)
      end
    end
  end


  describe 'PATCH #update' do
    context 'Authenticated user' do
      sign_in_user
      context 'operates with his own answer' do
        let!(:answer) { create(:answer, question: question, user: @user) }
        context 'with valid attributes' do
          it 'assigns the requested answer to @answer' do
            patch :update, question_id: question, id: answer, answer: attributes_for(:answer), format: :js
            expect(assigns(:answer)).to eq answer
          end

          it 'changes answer attributes' do
            patch :update, question_id: question, id: answer, answer: { body: 'This is updated answer' }, format: :js
            answer.reload
            expect(answer.body).to eq 'This is updated answer'
          end

          it 'sends back status ok and renders update partial' do
            patch :update, question_id: question, id: answer, answer: { body: 'This is updated answer' }, format: :js
            expect(response.status).to eq 200
            expect(response).to render_template 'answers/update'
          end
        end

        context 'with invalid attributes' do
          before { patch :update, question_id: question, id: answer, answer: { body: nil }, format: :js }
          it 'does not change answer attributes' do
            answer.reload
            expect(answer.body).to eq 'This is the Answer body'
          end

          it 're-renders edit view' do
            expect(response).to render_template 'answers/edit'
          end
        end
      end

      context 'operates with another user answer' do
        sign_in_another_user
        let!(:answer) { create(:answer, question: question, user: @user) }
        before { patch :update, question_id: question, id: answer, answer: { body: 'This is another user answer' }, format: :js }

        it 'does not change answer attributes' do
          answer.reload
          expect(answer.body).to eq 'This is the Answer body'
        end
      end
    end

    context 'Non-authenticated' do
      it 'redirects to question path' do
        patch :update, question_id: question, id: answer, answer: { body: 'I am SkyNet!' }, format: :js
        expect(response.status).to eq 401
      end
    end

  end


  describe 'PATCH #set_best' do
    context 'Authenticated user' do
      sign_in_user
      context 'operates with his own question answers' do
        let!(:question) { create(:question, user: @user) }
        let!(:answer) { create(:answer, question: question, user: user) }
        let!(:another_answer) { create(:answer, question: question, user: user) }

        it 'assigns the requested answer to @answer' do
          patch :set_best, question_id: question, id: answer, format: :js
          expect(assigns(:answer)).to eq answer
        end

        it "set's best answer" do
          patch :set_best, question_id: question, id: answer, format: :js
          answer.reload
          expect(answer.best_answer).to eq true
        end

        it 'best answer can be only one' do
          patch :set_best, question_id: question, id: another_answer, format: :js
          answer.reload
          another_answer.reload
          expect(answer.best_answer).to eq false
          expect(another_answer.best_answer).to eq true
        end

        it 're-renders answer as best' do
          patch :set_best, question_id: question, id: answer
          expect(response).to redirect_to question
        end
      end


      context 'operates with another users question answer' do
        sign_in_another_user
        let!(:question) { create(:question, user: user) }
        let!(:answer) { create(:answer, question: question, user: user) }

        before { patch :set_best, question_id: question , id: answer, format: :js }
        it 'redirects to question view' do
          expect(response).to redirect_to question
        end

        it 'does not change answer attributes' do
          answer.reload
          expect(answer.best_answer).to eq false
        end
      end
    end

    context 'Non-authenticated' do
      before { answer }
      it 'unauthorized' do
        patch :set_best, id: answer, question_id: question, format: :js
        expect(response.status).to eq(401)
      end
    end

  end





  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      sign_in_user
      before { answer }

      context 'operates with his own answer' do
        let!(:answer) { create(:answer, question: question, user: @user) }

        it 'deletes his own answer' do
          expect {delete :destroy, question_id: question, id: answer, format: :js }.to change(@user.answers, :count).by(-1)
        end

        it 'gets status ok to answer view' do
          delete :destroy, question_id: question, id: answer, format: :js
          expect(response.status).to eq 200
        end
      end

      context "operates with other user's answer" do
        sign_in_another_user
        let!(:answer) { create(:answer, question: question, user: @user) }

        it "can't delete answer" do
          expect { delete :destroy, question_id: question, id: answer, format: :js }.to_not change(Answer, :count)
        end

        it 'unauthorized' do
          delete :destroy, question_id: question, id: answer, format: :js
          expect(response.status).to eq 401
        end
      end
    end

    context 'Non-authenticated user try to delete answer' do
      before { answer }
      it 'unauthorized' do
        expect { delete :destroy, question_id: question, id: answer, format: :js }.to_not change(Answer, :count)
        expect(response.status).to eq 401
      end
    end
  end



end
