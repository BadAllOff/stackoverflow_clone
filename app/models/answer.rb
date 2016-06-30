# == Schema Information
#
# Table name: answers
#
#  id           :integer          not null, primary key
#  body         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  question_id  :integer
#  user_id      :integer
#  best_answer  :boolean          default(FALSE)
#  rating_index :integer          default(0)
#

class Answer < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  validates :body, :user, :question, presence: true

  default_scope -> { order(best_answer: :desc).order(created_at: :desc) }

  def set_best
    ActiveRecord::Base.transaction do
      question.answers.update_all(best_answer: false)
      best_answer ? update!(best_answer: false) : update!(best_answer: true)
    end
  end

end
