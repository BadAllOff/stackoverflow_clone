require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) {nil}

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user)                { create :user }
    let(:other_user)          { create :user }
    let(:question)            { create :question, user: user }
    let(:other_question)      { create :question, user: other_user }
    let(:answer)              { create :answer, question: question, user: user }
    let(:other_answer)        { create :answer, user: other_user, question: question }
    let(:attachment)          { create :attachment, attachable: question }
    let(:comment)             { create :comment, commentable: question, user: user }
    let(:other_comment)       { create :comment, commentable: question, user: other_user}

    #All
    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
    # Question
    it { should be_able_to :crud, Question, user: user }
    it { should_not be_able_to :crud, create(:question, user: other_user), user: user }
    # Answer
    it { should be_able_to :crud, Answer, user: user }
    it { should_not be_able_to :crud, create(:answer, user: other_user), user: user }
    it { should be_able_to :set_best, answer, user: user }
    it { should_not be_able_to :set_best, create(:answer), user: user }
    # Attachment
    it { should be_able_to :manage, attachment, user: user }
    it { should be_able_to :destroy, attachment, user: user }
    it { should_not be_able_to :manage, create(:attachment), user: other_user }
    # Comment
    it { should be_able_to :create, Comment }
    it { should be_able_to :destroy, comment, user: user }
    it { should_not be_able_to :manage, create(:comment, commentable: question, user: other_user), user: user }
    # Vote
    it { should be_able_to :vote, other_question, user: user }
    it { should_not be_able_to :vote, question, user: user }
    it { should be_able_to :vote, other_answer, user: user }
    it { should_not be_able_to :vote, question, user: user }

  end
end
