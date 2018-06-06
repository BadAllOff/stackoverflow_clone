# == Schema Information
#
# Table name: subscriptions
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  question_id :integer
#

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question, touch: true

  validates :question_id, :user_id, presence: true
end
