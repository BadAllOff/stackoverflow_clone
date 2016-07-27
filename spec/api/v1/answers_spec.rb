require 'rails_helper'

describe 'Answer API' do
  let!(:question) { create :question }

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answer) { create(:answer, question: question) }
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it '- included in answer object' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at best_answer).each do |attr|
        it "- contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like "API Authenticable"
    let!(:answer) { create(:answer, question: question) }

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment_answer) { create(:comment, commentable: answer) }
      let!(:attachment_answer) { create(:attachment, attachable: answer) }

      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it_behaves_like 'Status  200, successful'

      %w(id body created_at updated_at best_answer).each do |attr|
        it "- answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      context 'comments' do
        %w(id content created_at updated_at).each do |attr|
          it "- answer object contains comment with #{attr}" do
            expect(response.body).to be_json_eql(comment_answer.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        %w(id created_at updated_at).each do |attr|
          it "- answer object contains attachment with #{attr}" do
            expect(response.body).to be_json_eql(attachment_answer.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end

        it '- attachment contains url' do
          expect(response.body).to be_json_eql(attachment_answer.file.url.to_json).at_path("attachments/0/url")
        end

        it '- attachment contains name' do
          expect(response.body).to have_json_path("attachments/0/name")
        end
      end

    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end


  describe 'POST /create' do
    it_behaves_like "API Authenticable"

    context 'Authenticated user' do
      let(:me) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      context 'with valid attributes' do
        it '- returns 200 status code' do
          post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token
          expect(response).to be_success
        end

        it '- saved as current user owner' do
          expect { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token }.to change(me.answers, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it '- returns 422 status' do
          post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token
          expect(response.status).to eq 422
        end

        it '- answer quantity should not be change' do
          expect { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }.to_not change(Answer, :count)
        end
      end
    end

    def do_request(options = {})
       post "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

end