require_relative '../acceptance_helper'

feature 'Add comment question' do

  given(:user)         { create(:user) }
  given(:another_user) { create(:user) }
  given(:question)     { create(:question, user: user) }
  given!(:comment)     { create(:comment, user: user, commentable: question) }

  describe 'Authenticated user' do
    context 'operates his own comment' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario '- see delete button' do
        within '.question_comments' do
          expect(page).to have_selector(:link_or_button, 'Delete comment')
        end
      end

      scenario '- destroy own comment', js: true do
        # skip 'Capybara problem with pub\sub and Commet' do
          within('.question_comments') { click_on 'Delete comment' }
          page.evaluate_script 'window.location.reload()'
          expect(page).to_not have_content comment.content
        # end
      end
    end

    context 'operates other user comment' do
      before do
        sign_in(another_user)
        visit questions_path
      end

      scenario "- can't see control buttons for other users comment" do
        expect(page).to_not have_css('.delete_question_comment')
      end
    end
  end

  describe 'Non-Authenticated user' do
    context 'remove other users comments' do
      before do
        sign_in(another_user)
        visit questions_path
      end

      scenario "- can't see control buttons for other users comment" do
        expect(page).to_not have_css('.delete_question_comment')
      end
    end
  end

end