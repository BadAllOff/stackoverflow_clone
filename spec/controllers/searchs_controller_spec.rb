require 'rails_helper'

RSpec.describe SearchsController, type: :controller do

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #results' do
    it 'returns http success' do
      post :results, search_query: {query: 'question', index_type: 'nil'}
      expect(response).to have_http_status(:success)
    end

    it 'returns http success' do
      post :results, search_query: {query: 'question', index_type: 'Questions'}
      expect(response).to have_http_status(:success)
    end

    it 'returns http success' do
      post :results, search_query: {query: 'answer', index_type: 'Answers'}
      expect(response).to have_http_status(:success)
    end

    it 'returns http success' do
      post :results, search_query: {query: 'comment', index_type: 'Comments'}
      expect(response).to have_http_status(:success)
    end

    it 'returns http success' do
      post :results, search_query: {query: 'username', index_type: 'Users'}
      expect(response).to have_http_status(:success)
    end
  end

end
