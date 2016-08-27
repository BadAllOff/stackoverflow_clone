# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  file            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  attachable_id   :integer
#  attachable_type :string
#

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  describe 'Associations' do
    it { should belong_to :attachable }
  end

  describe 'Validations' do
    it { should validate_presence_of :file }
  end
end
