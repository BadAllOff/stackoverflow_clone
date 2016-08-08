require 'rails_helper'

RSpec.describe Vote, type: :model do

  describe 'Associations' do
    it { should belong_to :user }
    it { should belong_to :votable }
  end

  describe 'Validations' do
    it { should validate_presence_of :value }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :votable_id }
    it { should validate_presence_of :votable_type }
  end
end
