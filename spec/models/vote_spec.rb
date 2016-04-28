require 'rails_helper'

RSpec.describe Vote, type: :model do

  describe 'Associations' do
    it { should belong_to :user }
    it { should belong_to :votable }
  end

  describe 'Validations' do
    it { should validate_presence_of :value }
    # it { should validate_uniqueness_of(:user_id).scoped_to(:votable_type, :votable_id) }
  end

  describe 'uniqueness validation' do
    # let!(:user)      { create(:user) }
    # let!(:question)  { create(:question, user: user) }
    # let!(:vote) do
    #   create(:vote,
    #          user_id: user.id,
    #          votable_type: question,
    #          votable_id: question.id,
    #          value: 1 )
    # end
    # let!(:duplicated_vote) do
    #   create(:vote,
    #          user_id: user.id,
    #          votable_type: question,
    #          votable_id: question.id,
    #          value: 1 )
    # end



    # it do
    #   subject { create(:vote, user_id: user, votable_type: question, votable_id: question.id) }
    #   should validate_uniqueness_of(:user).scoped_to(:votable_type, :votable_id)
    # end
  end
end
