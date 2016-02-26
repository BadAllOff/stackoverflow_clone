require 'rails_helper'

RSpec.describe User do

  describe 'Associations' do
    it { should have_many(:questions).dependent(:destroy)}
    it { should have_many(:answers).dependent(:destroy)}
    it { should have_many(:votes).dependent(:destroy)}
  end

  describe 'Validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:username) }
  end

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:attachment) { create(:attachment, attachable: question) }

  describe 'author_of?' do

    it 'question author_of?' do
      expect(user.author_of?(question)).to be_truthy
    end

    it 'answer author_of?' do
      expect(user.author_of?(answer)).to be_truthy
    end

    it 'attachment author_of?' do
      expect(user.author_of?(attachment.attachable)).to be_truthy
    end

  end

end
