require_relative '../../acceptance/acceptance_helper'
feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  describe 'Authenticated user' do
    context 'creates new question' do
      before do
        sign_in(user)
        visit new_question_path
      end

      scenario '- adds attachment when asks question', js: true do
        within('form#new_question') do
          fill_in 'Title', with: 'Test question title'
          fill_in 'Body', with: 'Test question body'
          click_on 'Add file'
          attach_file 'File', "#{Rails.root}/spec/fixtures/10x10.jpg"
          click_on 'Create Question'
        end

        expect(page).to have_link '10x10.jpg', href: '/uploads/attachment/file/1/10x10.jpg'
      end

      scenario '- adds attachment when asks question, but changes his mind, deletes file field from form', js: true do
        within('form#new_question') do
          fill_in 'Title', with: 'Test question title'
          fill_in 'Body', with: 'Test question body'
          click_on 'Add file'
          attach_file 'File', "#{Rails.root}/spec/fixtures/10x10.jpg"
          click_on 'Remove file'
          click_on 'Create Question'
        end

        expect(page).to_not have_link '10x10.jpg', href: '/uploads/attachment/file/1/10x10.jpg'
      end

      scenario '- could add several files when asks question', js: true do
        within('form#new_question') do
          fill_in 'Title', with: 'Test question title'
          fill_in 'Body', with: 'Test question body'
          click_on 'Add file'
          all('input[type="file"]')[0].set "#{Rails.root}/spec/fixtures/20x20.jpg"
          click_on 'Add file'
          all('input[type="file"]')[1].set "#{Rails.root}/spec/fixtures/20x20.jpg"
          click_on 'Create Question'
        end

        expect(page).to have_link('20x20.jpg', count: 2)
      end
    end

  end

  describe 'Non-Authenticated user' do
    scenario '- redirected to sign in page' do
      visit new_question_path
      expect(current_path).to eq new_user_session_path
    end
  end

end
