require_relative '../../acceptance/acceptance_helper'

feature 'Best Answer', '
        In order to choose best answer to question
        As an authenticated user
        I want be able vote for answer
  ' do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    context 'operates with his own question' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario '- can select "Best answer" to his question', js: true do
        first('div.vote').click_link('Accept answer')
        within(first('div.vote')) { expect(page).to have_selector(:link_or_button, 'Best answer') }
        expect(page).to have_content 'Answer successfully set as best.'
      end

      scenario '- "Best answer" can be only one, and it appears first in the list of answers after reload', js: true do
        first('div.vote').click_link('Accept answer')
        all('div.vote').last.click_link('Accept answer')
        visit question_path(question)

        expect(all('div.vote').last).to have_css('a.vote-accepted-off')
        expect(all('div.vote').first).to have_css('a.vote-accepted-on')
      end

      scenario '- can unselect best answer for his question', js: true do
        first('div.vote').click_link('Accept answer')
        first('div.vote').click_link('Best answer')

        expect(page).to_not have_css('.vote-accepted-on')
      end
    end

    context "operates with other user's question" do
      before do
        sign_in(another_user)
        visit question_path(question)
      end

      scenario "- can't see 'Best answer' button" do
        expect(page).to_not have_selector(:link_or_button, 'Accept answer')
      end
    end

  end

  describe 'Non-Authenticated user' do
    before { visit question_path(question) }

    scenario "- can't see 'Best answer' button" do
      expect(page).to_not have_selector(:link_or_button, 'Accept answer')
    end
  end


end
