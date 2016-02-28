class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true

  # TODO: - how to test this scope?
  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }


  # TODO: - how to test this scope?
  scope :upvotes,   -> { where(value: 1) }
  scope :downvotes, -> { where(value: -1) }
  scope :rating,    -> { sum(:value) }
end
