shared_examples_for 'API Authenticable' do
  context 'Not authenticated user' do
    it 'returns 401 status if there is no access_token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(access_token: 123456)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'Status  200, successful' do
  it 'returns 200 status' do
    expect(response).to be_success
  end
end
