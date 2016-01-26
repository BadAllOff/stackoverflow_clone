require 'rails_helper'

feature 'Register', %q(
  In order to be able ask questions
  As an user
  I want be able to sign in
 ) do

  scenario 'Registered user try to sign in' do
    User.create!(email: 'good@user.com', password: 'goodpassword')

    visit new_user_session_path
    fill_in 'Email', with: 'good@user.com'
    fill_in 'Password', with: 'goodpassword'
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@user.com'
    fill_in 'Password', with: '12345'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq new_user_session_path
  end
end
