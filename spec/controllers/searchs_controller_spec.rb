require 'rails_helper'

RSpec.describe SearchsController, type: :controller do

  describe 'GET #index' do
    it '- returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #results' do
    it '- returns http success' do
      post :results, search_query: {query: 'question', index_type: 'nil'}
      expect(response).to have_http_status(:success)
    end

    %w(question answer comment user).each do |attr|
      it "- returns http success for index #{attr.pluralize.capitalize}" do
        post :results, search_query: {query: attr, index_type: "#{attr.pluralize.capitalize}" }
        expect(response).to have_http_status(:success)
      end
    end
  end

end
