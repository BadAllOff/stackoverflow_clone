require_relative '../../acceptance/acceptance_helper'
feature 'Update question attachments', %q{
  In order to illustrate better my question
  As an question's author
  I'd like to be able to update attached files
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  describe 'Authenticated user' do

    context 'operates with his own answer' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario '- add additional files to question and update', js: true do
        within('div#question_container') do
          click_on 'Edit question'
          click_on 'Add file'
          attach_file 'File', "#{Rails.root}/spec/fixtures/20x20.jpg"
          click_on 'Update Question'
        end

        expect(page).to have_link '20x20.jpg', href: '/uploads/attachment/file/2/20x20.jpg'
      end

      scenario '- add additional files to question, but changes his mind, deletes file field from form', js: true do
        within('div#question_container') do
          click_on 'Edit question'
          click_on 'Add file'
          attach_file 'File', "#{Rails.root}/spec/fixtures/20x20.jpg"
          click_on 'Remove file'
          click_on 'Update Question'
        end

        expect(page).to_not have_link '20x20.jpg', href: '/uploads/attachment/file/2/20x20.jpg'
      end

    end

    context "- can't operate other users question" do
      before  do
        sign_in(another_user)
        visit question_path(question)
      end

      scenario "- can't see control buttons for other users question" do
        expect(page).to_not have_css('div.question_control_btns')
      end
    end
  end


  describe 'Non-Authenticated user' do
    scenario "- can't see control buttons at all " do
      visit question_path(question)
      expect(page).to_not have_css('div.question_control_btns')
    end
  end

end
