require_relative '../../acceptance/acceptance_helper'
feature 'Update answer attachments', %q{
  In order to illustrate better my answer
  As an answers's author
  I'd like to be able to update attached files
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  describe 'Authenticated user' do

    context 'operates with his own answer' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario '- add additional files to answer and update', js: true do
        within("li#answer-#{answer.id}") do
          click_on 'Edit answer'
          click_on 'Add file'
          attach_file 'File', "#{Rails.root}/spec/fixtures/20x20.jpg"
          click_on 'Update Answer'
        end

        within("li#answer-#{answer.id}") { expect(page).to have_link '20x20.jpg', href: '/uploads/attachment/file/2/20x20.jpg' }
      end

      scenario '- add additional files to answer, changes his mind, removes attachment field', js: true do
        within("li#answer-#{answer.id}") do
          click_on 'Edit answer'
          click_on 'Add file'
          attach_file 'File', "#{Rails.root}/spec/fixtures/20x20.jpg"
          click_on 'Remove file'
          click_on 'Update Answer'
        end

        within("li#answer-#{answer.id}") { expect(page).to_not have_link '20x20.jpg', href: '/uploads/attachment/file/2/20x20.jpg' }
      end
    end

    context 'operates with other users answers' do
      before  do
        sign_in(another_user)
        visit question_path(question)
      end

      scenario "- can't see control buttons for other users answer" do
        expect(page).to_not have_css('div.answer_control_btns')
      end
    end

  end

  describe 'Non-Authenticated user' do
    before { visit question_path(question) }

    scenario "- can't see control buttons at all " do
      expect(page).to_not have_css('div.answer_control_btns')
    end
  end

end
