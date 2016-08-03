require_relative '../../acceptance/acceptance_helper'

feature 'Subscription' do

  given!(:current_user) { create(:user) }
  given!(:question) { create(:question, user: current_user) }

  describe 'Authenticated user' do
    before do
      sign_in(current_user)
      visit question_path(question)
      click_on "Subscribe"
    end
  end
    scenario '- subscribes to question' do
      expect(page).to_not have_selector(:link_or_button, "Subscribe")
    end

    scenario '- unsubscribes from question' do
      click_on "Unsubscribe"
      expect(page).to_not have_selector(:link_or_button, "Unsubscribe")
    end
  end

  describe 'Non-Authenticated user' do
    before { visit question_path(question) }

    scenario "- can't see subscribe button" do
      expect(page).to_not have_selector(:link_or_button, "Subscribe")
      expect(page).to_not have_selector(:link_or_button, "Unsubscribe")
      expect(page).to have_content "You are not authorized to access this page."
    end

end
