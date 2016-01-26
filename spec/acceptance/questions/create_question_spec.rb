require 'rails_helper'

feature 'Create Question', %q(
        In order to get answer from community
        As an authenticated user
        I want be able to ask questions
  ) do

  scenario 'Authenticated user creates question' do
    User.create!(email: 'good@user.com', password: 'goodpassword')

    visit new_user_session_path
    fill_in 'Email', with: 'good@user.com'
    fill_in 'Password', with: 'goodpassword'
    click_on 'Log in'

    visit questions_path
    click_on 'Ask Question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test question body'
    click_on 'Create Question'

    expect(page).to have_content 'Question successfully created'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Test question body'
  end


  scenario 'Non-authenticated user try to create question' do
    visit questions_path
    click_on 'Ask Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end




end
