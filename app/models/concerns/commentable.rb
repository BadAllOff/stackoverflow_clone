module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :destroy
    scope :with_comments, -> {
      includes(:comments)
    }
  end
end