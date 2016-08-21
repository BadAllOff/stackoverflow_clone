class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :content, :user_id, :commentable_id, :commentable_type, presence: true

  default_scope -> { order(id: :asc) }
end
