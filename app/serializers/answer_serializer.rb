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

class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :best_answer, :created_at, :updated_at
  has_many :comments
  has_many :attachments
end
