require 'rails_helper'

feature 'Create Answer', %q(
        In order to give answer to question
        As an authenticated user
        I want be able write answer
  ) do

  given(:user) { create(:user) }
  given(:question) { create(:question) }


  scenario 'Authenticated user creates answer to the given question' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Write your answer', with: 'My answer to question'
    click_on 'Create answer'

    expect(page).to have_content 'Answer successfully created'
    expect(page).to have_content question.title
    expect(page).to have_content 'My answer to question'
  end

  scenario "Non-authenticated user can't see button to create answer " do
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Create answer')
  end

end
