require_relative '../../acceptance/acceptance_helper'

feature 'Delete Question', %q(
        In order to not look like a spamer
        As an authenticated user
        I want be able to delete my irrelevant question
  ) do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }


  describe 'Authenticated user' do
    context 'operates his own question' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario '- deletes own question' do
        click_on 'Delete question'

        expect(page).to have_content 'Your question successfully deleted.'
        expect(page).to_not have_content question.title
        expect(current_path).to eq questions_path
      end
    end

    context 'operates other user answer' do
      before do
        sign_in(another_user)
        visit questions_path
      end

      scenario "- can't see question control buttons other user question" do
        expect(page).to_not have_css('.question_control_btns')
      end
    end

  end

  describe 'Non-Authenticated user' do
    before { visit question_path(question) }

    scenario "- can't see question control buttons at all" do
      expect(page).to_not have_css('.question_control_btns')
    end
  end

end
