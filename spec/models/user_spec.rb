require 'rails_helper'

RSpec.describe User do

  describe 'Associations' do
    it { should have_many(:questions).dependent(:destroy)}
    it { should have_many(:answers).dependent(:destroy)}
    it { should have_many(:votes).dependent(:destroy)}
    it { should have_many(:comments).dependent(:destroy)}
    it { should have_many(:authorizations).dependent(:destroy)}
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

  describe '#non_author_of?' do
    it '- non_author_of? returns false if author' do
      expect(user.non_author_of?(answer)).to be_falsey
    end

    it '- non_author_of? returns true if not an author' do
      expect(another_user.non_author_of?(answer)).to be_truthy
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

  describe '.find_for_oauth'  do
    let!(:user) { create(:user) }
    let(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it '- returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it '- does not create new user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it '- creates new authorization for user' do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by 1
        end

        it '- creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it '- returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'goodexample@email.com' }) }

        it '- creates new user' do
          expect{ User.find_for_oauth(auth) }.to change(User, :count).by 1
        end

        it '- returns new user' do
          expect(User.find_for_oauth(auth)).to be_a User
        end

        it '- fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it '- creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).not_to be_empty
        end

        it '- creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end

  end

end
