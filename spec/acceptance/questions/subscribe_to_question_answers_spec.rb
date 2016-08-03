require_relative '../../acceptance/acceptance_helper'

feature 'Subscription' do

  given!(:current_user) { create(:user) }
  given!(:question) { create(:question, user: current_user) }

  scenario '- subscribe', js: true do
    sign_in(current_user)
    visit question_path(question)
    click_on "Subscribe"
    expect(page).to_not have_selector(:link_or_button, "Получать сообщение об ответах")
  end

  scenario '- unsubscribe', js: true do
    sign_in(current_user)
    visit question_path(question)
    click_on "Subscribe"
    click_on "Unsubscribe"
    expect(page).to_not have_selector(:link_or_button, "Unsubscribe")
  end

end
