require_relative '../../acceptance/acceptance_helper'

feature 'Create Question', %q(
        In order to get answer from community
        As an authenticated user
        I want be able to ask questions
  ) do

  given(:user) { create(:user) }
  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit questions_path
    end

    scenario '- creates question' do
      click_on 'Ask Question'
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test question body'
      click_on 'Create Question'

      expect(page).to have_content 'Question successfully created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Test question body'
    end
  end

  describe 'Non-Authenticated user' do

    scenario '- fails to create question and redirected to sign in page' do
      visit questions_path
      click_on 'Ask Question'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(current_path).to eq new_user_session_path
    end
  end

end
