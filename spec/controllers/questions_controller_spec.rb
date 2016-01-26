require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  # метод NEW не нуждаеться в создании объекта так как сам создаёт его автоматически
  describe 'GET #new' do
    sign_in_user
    before { get :new}

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question}

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'Authenticated user' do
      sign_in_user

      context 'with valid attributes' do
        it 'saves new question in the DB' do
          # old_count = Question.count
          # post :create, question: attributes_for(:question)
          # expect (Question.count).to eq old_count + 1
          expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, question: attributes_for(:question)
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end

      context 'with invalid attributes' do
        it 'does not saves new question in the DB' do
          expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, question: attributes_for(:invalid_question)
          expect(response).to render_template :new
        end
      end
    end

    context 'Non-authenticated user' do
      it 'fails to save new question in the DB' do
        post :create, question: attributes_for(:question)
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 'redirects to sign in page' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to new_user_session_path
      end
    end

  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      sign_in_user

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, id: question, question: attributes_for(:question)
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, id: question, question: { title: 'New Title', body: 'New Body' }
          question.reload
          expect(question.title).to eq 'New Title'
          expect(question.body).to eq 'New Body'
        end

        it 'redirects to updated question' do
          patch :update, id: question, question: attributes_for(:question)
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        before { patch :update, id: question, question: { title: 'New Title', body: nil } }
        it 'does not change question attributes' do
          question.reload
          expect(question.title).to eq 'This is Question title'
          expect(question.body).to eq 'This is Question body'
        end

        it 're-renders edit view' do
          expect(response).to render_template :edit
        end
      end

    end

    context 'Non-authenticated user' do
      it 'fails to update question attributes' do
        patch :update, id: question, question: { title: 'New Title', body: 'New Body' }
        question.reload
        expect(question.title).to_not eq 'New Title'
        expect(question.body).to_not eq 'New Body'
      end

      it 'redirects to sign in page' do
        patch :update, id: question, question: { title: 'New Title', body: 'New Body' }
        expect(response).to redirect_to new_user_session_path
      end
    end

  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      sign_in_user
      before { question }

      it 'deletes question' do
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'Non-authenticated user' do
      before { question }

      it 'fails to delete question' do
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it 'redirects to sign in page' do
        delete :destroy, id: question
        expect(response).to redirect_to new_user_session_path
      end
    end

  end


end
