require_relative '../../acceptance/acceptance_helper'

feature 'Create Answer', %q(
        In order to give answer to question
        As an authenticated user
        I want be able write answer
  ) do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario '- creates answer to the given question', js: true do
      fill_in 'Answer body', with: 'My answer to question'
      click_on 'Create Answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Answer successfully created'
      expect(page).to have_content 'My answer to question'
    end
  end

  describe 'Non-Authenticated user' do
    before { visit question_path(question) }

    scenario "- can't see button to create answer " do
      expect(page).to_not have_selector(:link_or_button, 'Create Answer')
    end
  end



end
