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

  scenario 'Authenticated user see "Edit" control buttons for his own answer' do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_css('div.answer_control_btns')
    within('div.answer_control_btns div.btn-group') { expect(page).to have_selector(:link_or_button, 'Edit answer') }
  end

  scenario 'Authenticated user edits his own answer to the given question' do
    sign_in(user)
    visit edit_question_answer_path(id: answer, question_id: question)
    fill_in 'Answer body', with: 'Edited answer body'
    click_on 'Update Answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content('Edited answer body')
  end


  scenario "Authenticated user can't see Answer control buttons for other users answer" do
  end


  scenario "Non-authenticated user can't see Answer control buttons at all " do
    visit question_path(question)
    expect(page).to_not have_css('div.answer_control_btns')
  end

end
