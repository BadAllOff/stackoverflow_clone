require_relative '../../acceptance/acceptance_helper'
require_relative '../sphinx_helper'

feature 'Querying the search', "
  In order to find the needed question
  As visitor
  I'd like to be able to use search
" do

  let!(:user)     { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer)   { create(:answer, user: user, question: question) }
  let!(:comment)  { create(:comment, user: user, commentable: answer) }

  context 'Any user' do
    before { visit search_path }
    context 'can use search' do

      scenario 'to find question' do
        fill_in 'search_query[query]', with: question.body
        select('Questions', from: 'search_query_index_type')
        click_on 'Find'
        expect(page).to have_content 'This is Question body'
      end

      scenario 'to find answer' do
        fill_in 'search_query[query]', with: answer.body
        select('Answers', from: 'search_query_index_type')
        click_on 'Find'
        expect(page).to have_content 'This is the Answer body'
      end

      scenario 'to find comment' do
        fill_in 'search_query[query]', with: comment.content
        select('Comments', from: 'search_query_index_type')
        click_on 'Find'
        expect(page).to have_content 'My comment text'
      end

      scenario 'to find user' do
        fill_in 'search_query[query]', with: user.username
        select('Users', from: 'search_query_index_type')
        click_on 'Find'
        expect(page).to have_content 'username'
      end

      scenario 'to find nothing' do
        fill_in 'search_query[query]', with: 'WhereIsMySocks?'
        click_on 'Find'
        expect(page).to have_content 'Sorry, I found nothing. You may try again.'
      end
    end
  end

end
