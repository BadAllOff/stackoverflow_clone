require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
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
  end

  describe 'GET /show' do
    let(:access_token) { create(:access_token) }
    let(:question) { create(:question) }

    context 'unauthorized' do
      it '- returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end

      it '- returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
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
  end

end
