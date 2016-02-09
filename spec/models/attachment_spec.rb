require 'rails_helper'

RSpec.describe Attachment, type: :model do

  describe 'Associations' do
    it { should belong_to :question }
  end
end
