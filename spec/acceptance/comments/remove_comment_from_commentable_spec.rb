require_relative '../acceptance_helper'

feature 'Add comment question' do

  given!(:user)         { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question)     { create(:question, user: user) }
  given!(:comment)      { create(:comment, user: user, commentable: question) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end
    context 'remove comment' do

      scenario '- destroy own comment', js: true do
        within ".question_comments" do
          click_on "Delete comment"
          expect(page).to_not have_content "My comment text"
        end
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
        expect(page).to_not have_css('.delete_answer_comment')
      end
    end
  end

end