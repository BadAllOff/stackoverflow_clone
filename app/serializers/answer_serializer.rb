class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :best_answer, :created_at, :updated_at
  has_many :comments
  has_many :attachments
end
