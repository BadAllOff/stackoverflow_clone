# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :integer
#  user_id     :integer
#  best_answer :boolean          default(FALSE)
#

class Answer < ApplicationRecord
  default_scope -> { order(best_answer: :desc).order(created_at: :desc) }

  include Attachable
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user

  validates :body, :user, :question, presence: true

  after_create :notify_subscribers


  def set_best
    ActiveRecord::Base.transaction do
      question.answers.update_all(best_answer: false)
      best_answer ? update!(best_answer: false) : update!(best_answer: true)
    end
  end

  def best?
    best_answer
  end

  def notify_subscribers
    NotifySubscribersJob.perform_later(self)
  end

end
