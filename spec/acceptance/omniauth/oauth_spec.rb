require_relative '../../acceptance/acceptance_helper'

feature 'OAuth' do
  before { OmniAuth.config.test_mode = true }
  before { visit new_user_session_path }

  describe 'Sign in through Facebook' do
    before { mock_auth_hash(:facebook) }

    it 'successfully' do
      within '#body_container' do
        click_on 'Sign in with Facebook'.last
      end
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end

  end

end