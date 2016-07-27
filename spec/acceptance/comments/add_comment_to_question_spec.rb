require_relative '../acceptance_helper'

feature 'Add comment question' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end
    context 'creates new comment' do
      scenario '- show form comment', js: true do
        within "#question_#{question.id}_comments" do
          expect(page).to_not have_selector :css, 'form.new_comment'
          click_on 'add a comment'
          expect(page).to have_selector :css, 'form.new_comment_form_for_question'
        end
      end

      scenario '- create comment', js: true do
        within "#question_#{question.id}_comments" do
          click_on 'add a comment'
          within 'form.new_comment_form_for_question' do
            fill_in 'write your comment', with: 'Test question comments'
            click_on 'Create Comment'
          end

          expect(current_path).to eq question_path(question)
        end

        within '.question_comments' do
          expect(page).to have_content 'Test question comments'
        end

        expect(page).to have_content 'Comment successfully created'
      end

      scenario '- with no content', js: true do
        within "#question_#{question.id}_comments" do
          click_on 'add a comment'
          within 'form.new_comment_form_for_question' do
            click_on 'Create Comment'
          end
          expect(page).to have_content "Content can't be blank"
        end
        expect(page).to have_content 'Please, check your input and try again'
      end
    end
  end

  describe 'Non-Authenticated user' do
    before { visit question_path(question) }

    scenario "- can't see button to add comment " do
      expect(page).to_not have_selector(:link_or_button, 'add a comment')
    end
  end


end
