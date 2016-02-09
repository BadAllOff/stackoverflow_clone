class Answer < ActiveRecord::Base
  has_many :attachments, dependent: :destroy, as: :attachable
  belongs_to :question
  belongs_to :user

  default_scope { order(best_answer: :desc).order(created_at: :desc) }

  validates :body, :user, :question, presence: true

  def set_best
    ActiveRecord::Base.transaction do
      question.answers.update_all(best_answer: false)
      best_answer ? update!(best_answer: false) : update!(best_answer: true)
    end
  end
end
