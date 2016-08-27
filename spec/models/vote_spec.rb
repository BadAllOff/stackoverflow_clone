# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  value        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  votable_type :string
#  votable_id   :integer
#

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
