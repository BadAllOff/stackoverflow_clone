require 'rails_helper'

RSpec.describe Attachment, type: :model do

  describe 'Associations' do
    it { should belong_to :attachable }
  end

  describe 'Validations' do
    it { should validate_presence_of :file }
  end
end
