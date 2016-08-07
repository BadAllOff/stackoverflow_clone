require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create :user }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it '- populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it '- renders index view' do
      expect(response).to render_template :index
    end
  end


  describe 'GET #show' do
    before { get :show, id: question }

    it '- assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it '- assigns new answer to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it '- builds new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it '- renders show view' do
      expect(response).to render_template :show
    end
  end


  describe 'GET #new' do
    sign_in_user
    render_views
    before { get :new}

    it '- assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it '- builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it '- renders new view' do
      expect(response).to render_template :new
    end
  end


  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question, format: :js}
    render_views

    it '- assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    # TODO: json
    it '- renders edit view' do
      expect(response).to have_http_status(:success)
    end
  end


  describe 'POST #create' do
    context 'Authenticated user' do
      sign_in_user

      context 'with valid attributes' do
        it '- saves new question in the DB' do
          expect { post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by(1)
        end

        it '- subscribes author to question' do
          expect { post :create, question: attributes_for(:question) }.to change(@user.subscriptions, :count).by(1)
        end

        it '- creates subscription to question' do
          expect { post :create, question: attributes_for(:question) }.to change(Subscription, :count).by(1)
        end

        it '- redirects to show view' do
          post :create, question: attributes_for(:question)
          expect(response).to redirect_to question_path(assigns(:question))
        end

        it_behaves_like 'Publishable' do
          let(:channel) { '/questions' }
          let(:object) { post :create, question: attributes_for(:question) }
        end
      end

      context 'with invalid attributes' do
        it '- does not saves new question in the DB' do
          expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
        end

        it '- re-renders new view' do
          post :create, question: attributes_for(:invalid_question)
          expect(response).to render_template :new
        end
      end
    end

    context 'Non-authenticated user' do
      it '- fails to save new question in the DB' do
        post :create, question: attributes_for(:question)
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it '- redirects to sign in page' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to new_user_session_path
      end
    end

  end


  describe 'PATCH #update' do
    context 'Authenticated user' do
      sign_in_user
      context 'operates with his own question via ajax' do
        let!(:question) { create(:question, user: @user) }

        context 'with valid attributes' do

          it '- assigns the requested question to @question' do
            patch :update, id: question, question: attributes_for(:question), format: :js
            expect(assigns(:question)).to eq question
          end

          it '- changes question attributes' do
            patch :update, id: question, question: { title: 'New Title', body: 'New Body' }, format: :js
            question.reload
            expect(question.title).to eq 'New Title'
            expect(question.body).to eq 'New Body'
          end

          it '- redirects to updated question' do
            patch :update, id: question, question: attributes_for(:question), format: :js
            expect(response).to have_http_status(:success)
          end
        end

        context 'with invalid attributes' do
          before { patch :update, id: question, question: { title: 'New Title', body: nil }, format: :js }
          it '- does not change question attributes' do
            question.reload
            expect(question.title).to eq 'This is Question title'
            expect(question.body).to eq 'This is Question body'
          end

          it '- re-renders edit view' do
            expect(response).to render_template(:edit)
          end

        end
      end

      context 'operates with another user question' do
        sign_in_another_user
        before { patch :update, id: question, question: { title: 'Update Title', body: 'Update Body' }, format: :js  }

        it '- does not change question attributes' do
          question.reload
          expect(question.title).to eq 'This is Question title'
          expect(question.body).to eq 'This is Question body'
        end
      end


    end

    context 'Non-authenticated user' do
      it '- fails to update question attributes' do
        patch :update, id: question, question: { title: 'New Title', body: 'New Body', format: :js  }
        question.reload
        expect(question.title).to_not eq 'New Title'
        expect(question.body).to_not eq 'New Body'
      end

      it '- redirects to sign in page' do
        patch :update, id: question, question: { title: 'New Title', body: 'New Body', format: :js  }
        expect(response).to redirect_to new_user_session_path
      end
    end

  end


  describe 'DELETE #destroy' do

    context 'Authenticated user' do
      sign_in_user
      before { question }
      context 'operates with his own question' do
        let!(:question) { create(:question, user: @user) }

        it '- deletes his own question' do
          expect { delete :destroy, id: question }.to change(@user.questions, :count).by(-1)
        end

        it '- redirect to index view' do
          delete :destroy, id: question
          expect(response).to redirect_to questions_path
        end
      end

      context "operates with other user's question" do
        sign_in_another_user
        before { question }

        it "deletes other user's question" do
          expect { delete :destroy, id: question }.to_not change(Question, :count)
        end

        it '- redirect to question view' do
          delete :destroy, id: question
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'Non-authenticated user' do
      before { question }

      it '- fails to delete question' do
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it '- redirects to sign in page' do
        delete :destroy, id: question
        expect(response).to redirect_to new_user_session_path
      end
    end

  end


  describe 'POST #subscribe' do
    context 'Authenticated user' do
      sign_in_user

      context 'operates with his own question' do
        let!(:question) { create(:question, user: @user) }

        it '- redirects to question' do
          post :subscribe, id: question
          expect(response).to redirect_to question_path(question)
        end

        it '- saves subscription in DB' do
          expect { post :subscribe, id: question }.to change(@user.subscriptions, :count).by(1)
        end
      end

      context "operates with other user's question" do
        before { question }

        it '- redirects to questions with warning' do
          post :subscribe, id: question
          expect(response).to redirect_to question_path(question)
        end

        it '- saves subscription in DB' do
          expect { post :subscribe, id: question }.to change(@user.subscriptions, :count).by(1)
        end
      end
    end

    context 'Non-authenticated user' do
      before { question }

      it '- redirects to sign in page' do
        post :subscribe, id: question
        expect(response).to redirect_to new_user_session_path
      end

      it '- does not save subscription in DB' do
        expect { post :subscribe, id: question }.to_not change(question.subscriptions, :count)
      end
    end
  end


  describe 'DELETE #unsubscribe' do
    context 'Authenticated user' do
      sign_in_user
      before do
        question
        post :subscribe, id: question
      end

      it '- redirects to question' do
        delete :unsubscribe, id: question
        expect(response).to redirect_to question_path(question)
      end

      it '- unsubscribes user if subscribed' do
        expect { delete :unsubscribe, id: question }.to change(question.subscriptions, :count).by(-1)
      end
    end

    context 'Non-authenticated user' do
      before { question }

      it '- redirects to sign in page' do
        delete :unsubscribe, id: question
        expect(response).to redirect_to new_user_session_path
      end

      it '- does not make changes to subscription table in DB' do
        expect { delete :unsubscribe, id: question }.to_not change(question.subscriptions, :count)
      end
    end
  end

  # Voting

  it_behaves_like 'Votable', 'Question' do
    let(:object) { create(:question, user: user) }
  end


end
