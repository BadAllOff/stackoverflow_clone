require_relative '../../acceptance/acceptance_helper'

feature 'Edit Question', %q(
        In order to update my question
        As an authenticated user
        I want be able to edit my question
  ) do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do

    context 'operates with his own question' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario '- sees control buttons for his own question' do
        expect(page).to have_css('.question_control_btns')
        within('.question_control_btns div.btn-group') do
          expect(page).to have_selector(:link_or_button, 'Edit question')
        end
      end

      scenario '- edits his own question', js: true do
        click_on 'Edit question'
        within("div.form_for_question-#{question.id}") do
          fill_in 'Title', with: 'Edited question title'
          fill_in 'Body', with: 'Edited question body'
          click_on 'Update Question'
        end

        expect(current_path).to eq question_path(question)
        expect(page).to have_content('Edited question title')
        expect(page).to have_content('Edited question body')
      end
    end

    context "operates with other user's question" do
      before do
        sign_in(another_user)
        visit question_path(question)
      end

      scenario '- cant see control buttons of other user question' do
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
