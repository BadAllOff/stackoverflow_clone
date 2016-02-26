require 'rails_helper'

describe AnswersController do
  let(:user) { create :user }
  let(:answer) { create :answer, user: user }
  let(:question) { create :question, user: user }
  before { sign_in(user) }

  describe 'PATCH #upvote' do
    it 'save upvote' do
      expect { patch :upvote, id: answer, format: :js }.to change(answer.votes.upvotes, :count).by 1
    end
  end
end
