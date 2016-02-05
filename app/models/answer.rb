class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  default_scope { order(best_answer: :desc).order(created_at: :desc) }

  validates :body, :user, :question, presence: true
end
