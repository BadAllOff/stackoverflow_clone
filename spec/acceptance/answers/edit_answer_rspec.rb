require 'rails_helper'

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
  end

  scenario 'Authenticated user edits his own answer to the given question' do
  end


  scenario "Authenticated user can't see Answer control buttons for other users answer" do
  end


  scenario "Non-authenticated user can't see Answer control buttons at all " do
    visit question_path(question)
    expect(page).to_not have_css('p.answer_control_btns')
  end

end
