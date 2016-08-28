require_relative '../../acceptance/acceptance_helper'

feature 'OAuth', tag: 'oauth' do
  before { OmniAuth.config.test_mode = true }
  before { visit new_user_session_path }

  describe 'Sign in through Facebook' do
    before { mock_auth_hash(:facebook) }

    it '- successfully' do
      within '#body_container' do
        click_on 'Sign in with Facebook'
      end
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end

    scenario '- with invalid credentials' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      within '#body_container' do
        click_on 'Sign in with Facebook'
      end
      expect(page).to have_content 'Authentication failed, please check your input and try again'
    end
  end


  describe 'Sign_in Github' do
    before { mock_auth_hash(:github) }

    scenario '- successfuly' do
      within '#body_container' do
        click_on 'Sign in with GitHub'
      end
      expect(page).to have_content "Email can't be blank"

      within '#omniauth_add_data_form' do
        fill_in 'Email', with: 'test@mail.ru'
        click_on 'Submit'
      end
      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    scenario '- with invalid credentials' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      within '#body_container' do
        click_on 'Sign in with GitHub'
      end
      expect(page).to have_content 'Authentication failed, please check your input and try again'
    end
  end


  describe 'Sign_in Twitter' do
    before { mock_auth_hash(:twitter) }

    scenario '- successfuly' do
      within '#body_container' do
        click_on 'Sign in with Twitter'
      end
      expect(page).to have_content "Email can't be blank"

      within '#omniauth_add_data_form' do
        fill_in 'Email', with: 'test@mail.ru'
        click_on 'Submit'
      end
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
    end

    scenario '- with invalid credentials' do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      within '#body_container' do
        click_on 'Sign in with Twitter'
      end
      expect(page).to have_content 'Authentication failed, please check your input and try again'
    end
  end


  describe 'Sign_in Vkontakte' do
    before { mock_auth_hash(:vkontakte) }

    scenario '- successfuly' do
      within '#body_container' do
        click_on 'Sign in with Vkontakte'
      end
      expect(page).to have_content "Email can't be blank"

      within '#omniauth_add_data_form' do
        fill_in 'Email', with: 'test@mail.ru'
        click_on 'Submit'
      end
      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end

    scenario '- with invalid credentials' do
      OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
      within '#body_container' do
        click_on 'Sign in with Vkontakte'
      end
      expect(page).to have_content 'Authentication failed, please check your input and try again'
    end
  end

end
