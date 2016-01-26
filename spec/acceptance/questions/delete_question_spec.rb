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

end
