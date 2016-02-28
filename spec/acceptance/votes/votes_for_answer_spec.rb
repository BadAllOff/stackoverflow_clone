require_relative '../../acceptance/acceptance_helper'

feature 'Votes for answer', %q{
        In order to express my opinion
        About given answers
        I'd like to be able to vote for them
} do

    given(:user) { create(:user) }
    given(:another_user) { create(:user) }
    given(:question) { create(:question, user: user) }
    given!(:answer) { create(:answer, question: question, user: user) }
    given!(:another_answer) { create(:answer, question: question, user: user) }

    describe 'Authenticated User' do
      context 'votes for his answer' do
        before do
          sign_in(user)
          visit question_path(question)
        end

        scenario "- can see vote btn for his own answer but can't upvote for it", js: true do
          within("#answer-#{answer.id}") { find('a.vote_answer_up').click }

          expect(page).to have_content("You can't vote for your own answer")
        end

        scenario "- can see vote btn for his own answer but can't downvote for it", js: true do
          within("#answer-#{answer.id}") { find('a.vote_answer_up').click }

          expect(page).to have_content("You can't vote for your own answer")
        end
      end

      context "votes for other user's answer" do
        before do
          sign_in(another_user)
          visit question_path(question)
        end

        scenario '- sees vote btn for other user answer' do
          within("#answer-#{answer.id}") do
            expect(page).to have_content('Vote Up')
            expect(page).to have_content('Vote Down')
          end
        end

        scenario "- vote's positively for answer of other user", js: true  do
          within("#answer-#{answer.id}") { find('a.vote_answer_up').click }

          expect(page).to have_content('You have successfully voted up for answer')
          expect(page).to have_selector(:link_or_button, 'Unvote')
          expect(page).to have_content(1)
        end

        scenario "- vote's negatively for answer of other user", js: true  do
          within("#answer-#{answer.id}") { find('a.vote_answer_down').click }

          expect(page).to have_content('You have successfully voted down for answer')
          expect(page).to have_selector(:link_or_button, 'Unvote')
          expect(page).to have_content(-1)
        end

        scenario "- user can't vote twice positively for one answer", js: true do
          within("#answer-#{answer.id}") do
            find('a.vote_answer_up').click

            expect(page).to_not have_selector(:link_or_button, 'Vote Up')
            expect(page).to     have_selector(:link_or_button, 'Unvote')
            expect(page).to     have_content(1)
          end
        end

        scenario "- user can't vote twice negatively for one answer", js: true do
          within("#answer-#{answer.id}") do
            find('a.vote_answer_down').click

            expect(page).to_not have_selector(:link_or_button, 'Vote Up')
            expect(page).to     have_selector(:link_or_button, 'Unvote')
            expect(page).to     have_content(-1)
          end
        end

        scenario '- user can cancel his vote and re-vote', js: true do
          within("#answer-#{answer.id}") do
            find('a.vote_answer_down').click
            sleep 1
            find('a.vote_answer_unvote').click
          end

          expect(page).to have_content('Your vote has been deleted. You can revote now')
          within("#answer-#{answer.id}") do
            expect(page).to have_selector(:link_or_button, 'Vote Up')
            expect(page).to have_selector(:link_or_button, 'Vote Down')
            expect(page).to have_content(0)
          end
        end

        scenario '- the user sees the result of their vote in the form of answers ranking', js: true do
          within("#answer-#{answer.id}") do
            find('a.vote_answer_down').click

            expect(page).to     have_selector(:link_or_button, 'Unvote')
            expect(page).to     have_content(-1)
          end
        end
      end

    end

    describe 'Non-Authenticated user' do
      before do
        visit question_path(question)
      end

      scenario "- can't see vote btns at all" do
        expect(page).to_not have_selector(:link_or_button, 'Vote Up')
        expect(page).to_not have_selector(:link_or_button, 'Vote Down')
      end

      scenario '- can see answer rating' do
        within("#answer-#{answer.id}") do
          expect(page).to     have_content(0)
        end
      end
    end


  end
