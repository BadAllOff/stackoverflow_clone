class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy

  validates :title, :body, :user, presence: true
end
