require_relative '../../acceptance/acceptance_helper'

feature 'Delete Question', %q(
        In order to not look like a spammer
        As an authenticated user
        I want be able to delete my irrelevant question
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

  scenario 'Authenticated user cant see Question control buttons of other user question' do
    sign_in(another_user)

    visit question_path(question)

    expect(page).to_not have_css('p.question_control_btns')
  end

  scenario "Non-authenticated user can't see Question control buttons at all" do
    visit question_path(question)
    expect(page).to_not have_css('p.question_control_btns')
  end

end
