require 'rails_helper'

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

  scenario 'Authenticated user edits own question' do
  end

  scenario 'Authenticated user cant see Question control buttons of other user question' do
  end

  scenario "Non-authenticated user can't see Question control buttons at all" do
    visit question_path(question)
    expect(page).to_not have_css('div.question_control_btns')
  end

end
