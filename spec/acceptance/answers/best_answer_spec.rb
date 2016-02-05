require_relative '../../acceptance/acceptance_helper'

feature 'Best Answer', %q(
        In order to choose best answer to question
        As an authenticated user
        I want be able vote for answer
  ) do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    context 'owner of question' do
      before do
        sign_in user
        visit question_path(question)
        first('div.vote').click_link('Accept')
      end

      scenario 'selects "Best answer" to his question' do
        expect(first('div.vote')).to have_css('a.vote-accepted-on')
      end

      scenario 'changes his mind and selects another "Best answer" to his question' do
        answers_vote_status = page.all('div.vote')
        answers_vote_status[1].click_link('Accept answer')

        expect(first('div.vote')).to have_css('a.vote-accepted-on')
        expect(answers_vote_status[1]).to have_css('a.vote-accepted-off')
      end

      scenario 'Best answer can be only one, and it appears first in the list of answers' do
        answers_vote_status = page.all('div.vote')
        answers_vote_status[1].click_link('Accept answer')

        expect(page).to have_css('a.vote-accepted-on')
      end

      scenario 'user can unselect best answer for his question' do
        first('div.vote').click_link('Best answer')

        expect(page).to_not have_css('.vote-accepted-on')
      end
    end

    context 'not owner of question' do
      before do
        sign_in(another_user)
        visit question_path(question)
      end

      scenario "cant see 'Best answer' button" do
        expect(page).to_not have_selector(:link_or_button, 'Accept answer')
      end

    end
  end


end
