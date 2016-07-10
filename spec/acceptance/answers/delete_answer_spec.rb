require_relative '../../acceptance/acceptance_helper'

feature 'Delete Answer', %q(
        In order to delete my answer to question
        As an authenticated user
        I want be able delete answer
  ) do

  given(:user)          { create(:user) }
  given(:another_user)  { create(:user) }
  given(:question)      { create(:question, user: user) }
  given!(:answer)       { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    context 'operates his own answer' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario '- sees delete btn for his own answer' do
        within('.answer_control_btns') { expect(page).to have_selector(:link_or_button, 'Delete answer') }
      end

      scenario '- deletes his own answer to the given question', js: true do
        within('.answer_control_btns') { click_on 'Delete answer' }

        expect(page).to have_content 'Answer successfully deleted'
        expect(page).to_not have_content answer.body
      end
    end

    context 'operates other user answer' do
      before do
        sign_in(another_user)
        visit questions_path
      end

      scenario "- can't see control buttons for other users answer" do
        expect(page).to_not have_css('.answer_control_btns')
      end
    end

  end


  describe 'Non-Authenticated user' do
    before { visit questions_path }

    scenario "- can't see control buttons for answer at all" do
      expect(page).to_not have_css('.answer_control_btns')
    end
  end

end
