class Answer < ActiveRecord::Base
  include Attachable
  include Votable

  belongs_to :question
  belongs_to :user

  validates :body, :user, :question, presence: true

  default_scope { order(best_answer: :desc).order(created_at: :desc) }

  def set_best
    ActiveRecord::Base.transaction do
      question.answers.update_all(best_answer: false)
      best_answer ? update!(best_answer: false) : update!(best_answer: true)
    end
  end

  def rating(sum)
    update!(rating_index: sum)
  end
end
