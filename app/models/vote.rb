class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true

  # TODO: - how to test this scope?
  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }
end
