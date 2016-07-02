require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Associations' do
    it { should belong_to :user }
    it { should belong_to :commentable }
  end

  describe 'Validations' do
    it { should validate_presence_of :content }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:commentable_type) }
    it { should validate_presence_of(:commentable_id) }
  end
end
