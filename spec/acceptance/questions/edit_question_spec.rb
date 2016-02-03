require_relative '../../acceptance/acceptance_helper'

feature 'Edit Question', %q(
        In order to update my question
        As an authenticated user
        I want be able to edit my question
  ) do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user see "Edit" control buttons for his own question' do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_css('div.question_control_btns')
    within('div.question_control_btns div.btn-group') { expect(page).to have_selector(:link_or_button, 'Edit question') }
  end

  scenario 'Authenticated user edits own question', js: true do
    sign_in(user)
    visit question_path(question)
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

  scenario 'Authenticated user cant see Question control buttons of other user question' do
    sign_in(another_user)
    visit question_path(question)
    expect(page).to_not have_css('div.question_control_btns')
  end

  scenario "Non-authenticated user can't see Question control buttons at all" do
    visit question_path(question)
    expect(page).to_not have_css('div.question_control_btns')
  end

end
