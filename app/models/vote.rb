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

class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, :user_id, :votable_id, :votable_type, presence: true

  # TODO: - how to test this scope?
  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }

  # TODO: - how to test this scope?
  scope :upvotes,   -> { where(value: 1) }
  scope :downvotes, -> { where(value: -1) }
  scope :rating,    -> { sum(:value) }
end
