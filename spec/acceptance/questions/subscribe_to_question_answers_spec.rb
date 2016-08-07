require_relative '../../acceptance/acceptance_helper'

feature 'Subscription' do

  given!(:current_user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question)     { create(:question, user: current_user) }
  given!(:subscription) { create(:subscription, user: current_user, question: question) }

  describe 'Authenticated user' do
    context 'operates his own question' do
      before do
        sign_in(current_user)
        visit question_path(question)
      end

      scenario '- can see subscribe/unsubscribe button' do
        expect(page).to have_selector(:link_or_button, 'Unsubscribe')
        click_on 'Unsubscribe'
        expect(page).to have_selector(:link_or_button, 'Subscribe')
      end
    end

    context 'operates with other users question' do
      before do
        sign_in(another_user)
        visit question_path(question)
      end
      scenario '- subscribes to question' do
        click_on 'Subscribe'

        expect(page).to_not have_selector(:link_or_button, 'Subscribe')
        expect(page).to have_selector(:link_or_button, 'Unsubscribe')
      end

      scenario '- unsubscribes from question' do
        click_on 'Subscribe'
        click_on 'Unsubscribe'
        expect(page).to have_selector(:link_or_button, 'Subscribe')
        expect(page).to_not have_selector(:link_or_button, 'Unsubscribe')
      end
    end

  end

  describe 'Non-Authenticated user' do
    before { visit question_path(question) }

    scenario "- can't see subscribe button" do
      expect(page).to_not have_selector(:link_or_button, 'Subscribe')
      expect(page).to_not have_selector(:link_or_button, 'Unsubscribe')
    end
  end

end
