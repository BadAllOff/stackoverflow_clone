require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to :votable }
  end

  describe 'Validations' do
    it { should validate_presence_of :value }
    # it { should validate_uniqueness_of(:user_id).scoped_to(:votable_type, :votable_id) }
  end

  # describe 'uniqueness validation' do
  #   subject { build(:user) }
  #   its (:id) {should eq(2)}
  #   it { should validate_uniqueness_of(:user_id).scoped_to(:votable_type, :votable_id) }
  # end
end
