require_relative '../../acceptance/acceptance_helper'

feature 'Edit Answer', %q(
        In order to correct my answer to question
        As an authenticated user
        I want be able edit my answer
  ) do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    context 'operates his own answer' do
      before do
        sign_in user
        visit question_path(question)
      end

      scenario 'see "Edit" control buttons for his own answer' do
        expect(page).to have_css('div.answer_control_btns')
        within('div.answer_control_btns div.btn-group') { expect(page).to have_selector(:link_or_button, 'Edit answer') }
      end

      context 'edit his own answer to the given question' do
        scenario 'with valid attributes', js: true do
          click_on 'Edit answer'
          within("div.form_for_answer-#{answer.id}") do
            fill_in 'Answer body', with: 'Edited answer body'
            click_on 'Update Answer'
          end
          expect(current_path).to eq question_path(question)
          expect(page).to have_content('Edited answer body')
          expect(page).to have_content('Answer successfully updated')
        end

        scenario 'with invalid attributes', js: true do
          click_on 'Edit answer'
          within("div.form_for_answer-#{answer.id}") do
            fill_in 'Answer body', with: nil
            click_on 'Update Answer'
          end
          expect(current_path).to eq question_path(question)
          expect(page).to have_content('Answer not updated')
        end
      end

    end

    context 'operates other user answer' do
      scenario "can't see Answer control buttons for other users answer" do
        sign_in(another_user)
        expect(page).to_not have_css('div.answer_control_btns')
      end
    end
  end


  scenario "Non-authenticated user can't see Answer control buttons at all " do
    visit question_path(question)
    expect(page).to_not have_css('div.answer_control_btns')
  end

end
