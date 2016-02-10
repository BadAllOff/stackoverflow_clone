require_relative '../../acceptance/acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  describe 'Authenticated user' do

    context 'creates new answer' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario '- with attachment', js: true do
        within 'form#new_answer' do
          fill_in 'Answer body', with: 'Test answer with attachment'
          click_on 'Add file'
          attach_file 'File', "#{Rails.root}/spec/fixtures/10x10.jpg"
          click_on 'Create Answer'
        end

        within '.answers' do
          expect(page).to have_content 'Test answer with attachment'
          expect(page).to have_link '10x10.jpg', href: '/uploads/attachment/file/1/10x10.jpg'
        end
      end

      scenario '- with several files attached', js: true do
        within 'form#new_answer' do
          fill_in 'Answer body', with: 'Test answer with attachments'
          click_on 'Add file'
          all('input[type="file"]')[0].set "#{Rails.root}/spec/fixtures/20x20.jpg"
          click_on 'Add file'
          all('input[type="file"]')[1].set "#{Rails.root}/spec/fixtures/20x20.jpg"
          click_on 'Add file'
          all('input[type="file"]')[2].set "#{Rails.root}/spec/fixtures/20x20.jpg"
          click_on 'Create Answer'
        end

        within '.answers_list' do
          expect(page).to have_content 'Test answer with attachments'
          expect(page).to have_link('20x20.jpg', count: 3)
        end
      end
    end

  end

  describe 'Non-Authenticated user' do
    scenario "- can't see button to create answer " do
      visit question_path(question)
      expect(page).to_not have_selector(:link_or_button, 'Create Answer')
    end
  end

end
