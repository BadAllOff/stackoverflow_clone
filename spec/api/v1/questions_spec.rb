require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'Authenticated user' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 3) }
      let!(:question) { questions.last }
      let!(:answer) { create(:answer, question: question)}

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it '- returns 200 status' do
        expect(response).to be_success
      end

      it '- returns list of questions' do
        expect(response.body).to have_json_size(3)
      end


      %w(id title body created_at updated_at).each do |attr|
        it "- question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it '- object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title")
      end

      context 'answers' do
        it '- included in object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at best_answer).each do |attr|
          it "- answer contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end

    end

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like "API Authenticable"
    let(:question) { create(:question) }

    context 'Authenticated user' do
      let(:access_token) { create(:access_token) }
      let!(:answer) { create(:answer, question: question) }
      let!(:comment_question) { create(:comment, commentable: question) }
      let!(:attachment_question) { create(:attachment, attachable: question) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it '- returns 200 status code' do
        expect(response).to be_success
      end

      context 'question' do
        %w(id title body created_at updated_at).each do |attr|
          it "- question object contains #{attr}" do
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
          end
        end

        it '- questions contains short_title' do
          expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("short_title")
        end
      end

      context 'comments' do
        %w(id content created_at updated_at).each do |attr|
          it "- question object contains comment with #{attr}" do
            expect(response.body).to be_json_eql(comment_question.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        %w(id created_at updated_at).each do |attr|
          it "- question object contains attachment with #{attr}" do
            expect(response.body).to be_json_eql(attachment_question.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end

        it '- attachment contains url' do
          expect(response.body).to be_json_eql(attachment_question.file.url.to_json).at_path("attachments/0/url")
        end

        it '- attachment contains name' do
          expect(response.body).to have_json_path("attachments/0/name")
        end
      end

    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end


  describe 'POST /create' do
    it_behaves_like "API Authenticable"

    context 'Authenticated user' do
      let(:me) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      context 'with valid attributes' do
        it '- returns 200 status' do
          post "/api/v1/questions", question: attributes_for(:question), format: :json, access_token: access_token.token
          expect(response).to be_success
        end

        it '- saved as current user owner' do
          expect { post "/api/v1/questions", question: attributes_for(:question), format: :json, access_token: access_token.token }.to change(me.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it '- returns 422 status' do
          post "/api/v1/questions", question: attributes_for(:invalid_question), format: :json, access_token: access_token.token
          expect(response.status).to eq 422
        end

        it '- question quantity should be not change' do
          expect { post "/api/v1/questions", question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }.to_not change(me.questions, :count)
        end
      end

    end

    def do_request(options = {})
      post '/api/v1/questions', { format: :json }.merge(options)
    end
  end

end
