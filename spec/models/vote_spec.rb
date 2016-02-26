require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'Associations' do
    it { should belong_to(:user) }
  end

  describe 'Validations' do
    it { should validate_presence_of :value }
  end
end
