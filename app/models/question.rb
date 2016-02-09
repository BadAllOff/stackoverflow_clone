class Question < ActiveRecord::Base
  include Attachable

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, :user, presence: true
end
