require_relative '../../acceptance/acceptance_helper'

feature 'Edit Answer', '
        In order to correct my answer to question
        As an authenticated user
        I want be able edit my answer
  ' do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    context 'operates with his own answer' do
      before do
        sign_in user
        visit question_path(question)
      end
      context 'can edit answer' do
        scenario '- can see "Edit answer" button' do
          expect(page).to have_css('.answer_control_btns')
          within('.answer_control_btns div.btn-group') { expect(page).to have_selector(:link_or_button, 'Edit answer') }
        end

        scenario '- with valid attributes', js: true do
          click_on 'Edit answer'
          within(".form_for_answer-#{answer.id}") do
            fill_in 'Answer body', with: 'Edited answer body'
            click_on 'Update Answer'
          end

          expect(current_path).to eq question_path(question)
          expect(page).to have_content('Edited answer body')
        end

        scenario '- with invalid attributes', js: true do
          click_on 'Edit answer'

          within(".form_for_answer-#{answer.id}") do
            fill_in 'Answer body', with: nil
            click_on 'Update Answer'
          end

          expect(current_path).to eq question_path(question)
          expect(answer.body).to eq answer.body
        end
      end
    end

    context "operates with other user's answer" do
      before { sign_in(another_user) }

      scenario "- can't see control buttons" do
        expect(page).to_not have_css('div.answer_control_btns')
      end
    end

  end

  describe 'Non-Authenticated user' do
    before { visit question_path(question) }

    scenario "- can't see answer control buttons at all " do
      expect(page).to_not have_css('div.answer_control_btns')
    end
  end

end
