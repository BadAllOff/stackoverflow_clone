require 'rails_helper'

feature 'Register', %q(
  In order to be able ask questions
  As an user
  I want be able to sign in
 ) do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end


  scenario 'Registered user try to sign out' do
    sign_in(user)

    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Registered user try to register new account and fails' do
    sign_in(user)
    visit new_user_session_path

    expect(page).to have_content 'You are already signed in.'
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

  scenario "Non-registered user try's to register new account" do
    visit root_path
    click_on 'Sign in'
    click_on 'Sign up'

    fill_in 'Username', with: 'New u2ername'
    fill_in 'Email', with: 'new@user.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

end
