require 'rails_helper'

feature 'Delete Question', %q(
        Only owner can remove the question
  ) do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user delete own question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Your question successfully deleted.'
    expect(page).to_not have_content question.title
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated user cant see delete button of other user question' do
    sign_in(another_user)

    visit question_path(question)

    within('p.question_control_btns') { expect(page).to_not have_selector(:link_or_button, 'Delete question') }
  end

  scenario "Non-authenticated user can't see Question controll buttons button " do
    visit question_path(question)
    expect(page).to_not have_css('p.question_control_btns')
  end


end
