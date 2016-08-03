require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'Associations' do
    it { should belong_to :user }
    it { should belong_to :question }
  end

  describe 'Validations' do
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :question_id }
  end

end
