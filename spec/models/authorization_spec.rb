require 'rails_helper'

RSpec.describe Authorization, type: :model do
  describe 'Associations' do
    it { should belong_to(:user) }
  end
end
