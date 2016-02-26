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

        scenario "- can see vote btn for his own answer but can't vote for it", js: true do
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
          within("#answer-#{answer.id}") { expect(page).to have_content('Vote Up') }
        end

        scenario "- vote's positively for answer of other user", js: true  do
          within("#answer-#{answer.id}") { find('a.vote_answer_up').click }

          expect(page).to have_content('You have successfully voted up for answer')
        end

        scenario "- vote's negatively for answer of other user", js: true  do

        end

        scenario "- user can't vote twice positivele or negativly for one answer" do

        end

        scenario '- user can cancel his vote and re-vote' do

        end

        scenario '- the user sees the result of their vote in the form of answers ranking' do

        end
      end
    end

    describe 'Non-Authenticated user' do
      scenario "- can't see vote btns at all" do

      end

      scenario '- can see answer rating' do

      end
    end


  end
