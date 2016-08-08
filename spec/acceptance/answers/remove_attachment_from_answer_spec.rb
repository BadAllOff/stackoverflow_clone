require_relative '../../acceptance/acceptance_helper'

feature 'Remove attachment from Question', '
        In order to update my question
        As an authenticated user
        I want be able to remove attachment from my question
  ' do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  describe 'Authenticated user' do
    context 'operates with own answer' do
      before do
        sign_in(user)
        question
        attachment
        visit question_path(question)
      end

      scenario '- can see remove button for attachments' do
        within('.answer_attachments') { expect(page).to have_selector(:link_or_button, 'Remove attachment') }
      end

      scenario '- can remove attachment', js: true do
        within('.answer_attachments') do
          click_on 'Remove attachment'
        end
        # sleep 1
        expect(page).to_not have_link '10x10.jpg', href: '/uploads/attachment/file/1/10x10.jpg'
      end
    end


    context  "operate with other users answers attachments" do
      before  do
        sign_in(another_user)
        visit question_path(question)
      end

      scenario "- can't see Remove attachment button for other users answer attachment" do
        within("li#attachment-#{attachment.id}") do
          expect(page).to_not have_link('Remove attachment')
        end
      end
    end

  end

  describe 'Non-Authenticated user' do
    before { visit question_path(question) }

    scenario "- can't see control buttons at all " do
      expect(page).to_not have_css('div.answer_control_btns')
      expect(page).to_not have_link('Remove attachment')
    end
  end

end
