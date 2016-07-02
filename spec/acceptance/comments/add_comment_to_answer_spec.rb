require_relative '../acceptance_helper'

feature 'Add comment to Answer' do

  given!(:user)     { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer)   { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    context 'creates new comment' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario '- show comment form', js: true do
        within ".answer_comments" do
          expect(page).to_not have_selector :css, 'form.new_comment'
          click_on 'add a comment'
          expect(page).to have_selector :css, 'form.new_comment_form_for_Answer'
        end
      end

      scenario '- create comment', js: true do
        within ".answer_comments" do
          click_on "add a comment"
          within 'form.new_comment_form_for_Answer' do
            fill_in 'write your comment', with: 'Test answer comments'
            click_on 'Create Comment'
          end

          expect(page).to have_content 'Test answer comments'
        end
      end
    end
  end


end