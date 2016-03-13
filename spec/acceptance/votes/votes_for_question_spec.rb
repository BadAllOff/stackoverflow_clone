require_relative '../../acceptance/acceptance_helper'

feature 'Votes for question', %q{
        In order to express my opinion
        About question
        I'd like to be able to vote for it
} do

  given(:user) { create(:user) }
    given(:another_user) { create(:user) }
    given(:question) { create(:question, user: user) }

    describe 'Authenticated User' do
      context 'votes for his question' do
        before do
          sign_in(user)
          visit question_path(question)
        end

        scenario "- can's see vote btn for his own Question and can't upvote for it", js: true do
          within("#question-#{question.id}") do
            expect(page).to_not have_selector(:link_or_button,  'Vote Up')
          end
        end

        scenario "- can't see vote btn for his own Question but can't downvote for it", js: true do
          within("#question-#{question.id}") do
            expect(page).to_not have_selector(:link_or_button,  'Vote Down')
          end
        end

      end

      context "votes for other user's question" do
        before do
          sign_in(another_user)
          visit question_path(question)
        end

        scenario '- sees vote btn for other user question' do
          within("#question-#{question.id}") do
            expect(page).to have_content('Vote Up')
            expect(page).to have_content('Vote Down')
          end
        end

      end
    end

end
