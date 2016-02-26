require 'rails_helper'

describe AnswersController do
  let(:user) { create :user }
  let(:another_user) { create :user }
  let(:answer) { create :answer, user: user }
  let(:question) { create :question, user: user }

  describe 'PATCH #upvote' do
    context 'votes up for his own answer' do
      before { sign_in(user) }
      it 'It does not keep the vote' do
        expect { patch :upvote, id: answer, format: :js }.to_not change(answer.votes.upvotes, :count)
      end
    end

    context "votes up for other user's answer" do
      before { sign_in(another_user) }
      it "It keep's the vote" do
        expect { patch :upvote, id: answer, format: :js }.to change(answer.votes.upvotes, :count).by 1
      end
    end
  end

  describe 'PATCH #downvote' do
    context 'votes down for his own answer' do
      before { sign_in(user) }
      it 'It does not keep the vote' do
        expect { patch :downvote, id: answer, format: :js }.to_not change(answer.votes.downvotes, :count)
      end
    end

    context "votes down for other user's answer" do
      before { sign_in(another_user) }
      it "It keep's the vote" do
        expect { patch :downvote, id: answer, format: :js }.to change(answer.votes.downvotes, :count).by 1
      end
    end
  end
end