require 'rails_helper'

feature 'Delete Answer', %q(
        In order to delete my answer to question
        As an authenticated user
        I want be able delete answer
  ) do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user see delete btn for his own answer' do
    sign_in(user)
    visit question_path(question)
    within('p.answer_control_btns') { expect(page).to have_selector(:link_or_button, 'Delete answer') }
  end

  scenario 'Authenticated user deletes his own answer to the given question' do
    sign_in(user)
    visit question_path(question)

    within('p.answer_control_btns') { click_on 'Delete answer' }

    expect(page).to have_content 'Answer successfully deleted'
    expect(page).to_not have_content answer.body
  end


  scenario "Authenticated user can't see Answer control buttons for other users answer" do
    sign_in(another_user)
    visit question_path(question)
    expect(page).to_not have_css('p.answer_control_btns')
  end


  scenario "Non-authenticated user can't see Answer control buttons at all " do
    visit question_path(question)
    expect(page).to_not have_css('p.answer_control_btns')
  end

end
