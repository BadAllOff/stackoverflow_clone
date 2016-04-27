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

        scenario "- vote's positively for question of other user", js: true  do
          within("#question-#{question.id}") { find('a.vote_up').click }

          expect(page).to have_content('You have successfully voted for Question')
          expect(page).to have_selector(:link_or_button, 'Unvote')
          expect(page).to have_content(1)
        end

        scenario "- vote's negatively for question of other user", js: true  do
          within("#question-#{question.id}") { find('a.vote_down').click }

          expect(page).to have_content('You have successfully voted for Question')
          expect(page).to have_selector(:link_or_button, 'Unvote')
          expect(page).to have_content(-1)
        end

        scenario "- user can't vote twice positively for one question", js: true do
          within("#question-#{question.id}") do
            find('a.vote_up').click

            expect(page).to_not have_selector(:link_or_button, 'Vote Up')
            expect(page).to     have_selector(:link_or_button, 'Unvote')
            expect(page).to     have_content(1)
          end
        end

        scenario "- user can't vote twice negatively for one question", js: true do
          within("#question-#{question.id}") do
            find('a.vote_down').click

            expect(page).to_not have_selector(:link_or_button, 'Vote Up')
            expect(page).to     have_selector(:link_or_button, 'Unvote')
            expect(page).to     have_content(-1)
          end
        end

        scenario '- user can cancel his vote and re-vote', js: true do
          within("#question-#{question.id}") do
            find('a.vote_down').click
            sleep 1
            find('a.vote_unvote').click
          end

          expect(page).to have_content('Your vote has been deleted. You can re-vote now')
          within("#question-#{question.id}") do
            expect(page).to have_selector(:link_or_button, 'Vote Up')
            expect(page).to have_selector(:link_or_button, 'Vote Down')
            expect(page).to have_content(0)
          end
        end

        scenario '- the user sees the result of their vote in the form of question ranking', js: true do
          within("#question-#{question.id}") do
            find('a.vote_down').click

            expect(page).to     have_selector(:link_or_button, 'Unvote')
            expect(page).to     have_content(-1)
          end
        end
      end
    end

end
