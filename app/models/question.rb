# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Question < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  include Attachable
  include Votable
  include Commentable
  include Subscribable

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, :user, presence: true

end
