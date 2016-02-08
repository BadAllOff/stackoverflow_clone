require 'rails_helper'

RSpec.describe User do

  describe 'Associations' do
    it { should have_many(:answers).dependent(:destroy)}
    it { should have_many(:questions).dependent(:destroy)}
  end

  describe 'Validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of(:email) }
    it { should validate_uniqueness_of(:username) }
  end

end
