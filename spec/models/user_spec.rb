require 'rails_helper'

RSpec.describe User do

  describe 'Associations' do
    it { should have_many(:questions).dependent(:destroy)}
    it { should have_many(:answers).dependent(:destroy)}
    it { should have_many(:votes).dependent(:destroy)}
    it { should have_many(:comments).dependent(:destroy)}
  end

  describe 'Validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:username) }
  end

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe '#author_of?' do

    it '- author_of? returns true if author' do
      expect(user.author_of?(answer)).to be_truthy
    end

    it '- author_of? returns false if not an author' do
      expect(another_user.author_of?(answer)).to be_falsey
    end

  end

  describe '#upvote_for answer' do
    it '- upvote by 1' do
      expect{ user.vote_for(answer, 1) }.to change(answer.votes.upvotes, :count).by(1)
    end
  end

  describe '#voted_for?' do
    it '- voted_for? returns false if not voted ' do
      expect(user.voted_for?(answer)).to be_falsey
    end

    it '- voted_for? returns true if voted ' do
      user.vote_for(answer, 1)
      expect(user.voted_for?(answer)).to be_truthy
    end
  end


  describe '#unvote_for' do
    it '- resets vote for answer' do
      user.vote_for(answer, 1)
      expect{ user.unvote_for(answer) }.to change(answer.votes.upvotes, :count).by(-1)
    end
  end

end
