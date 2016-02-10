require_relative '../../acceptance/acceptance_helper'

feature 'Remove attachment from Question', %q(
        In order to update my question
        As an authenticated user
        I want be able to remove attachment from my question
  ) do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }


  describe 'Authenticated user' do
    context 'operates with own question' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario '- sees remove button for question attachments' do
        within('.question_attachments') { expect(page).to have_selector(:link_or_button, 'Remove attachment') }
      end

      scenario '- removes attachment from his question', js: true do
        within('.question_attachments') do
          click_on 'Remove attachment'
        end

        expect(page).to_not have_link '10x10.jpg', href: '/uploads/attachment/file/1/10x10.jpg'
      end

    end

  end

end
