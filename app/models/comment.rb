# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
#  commentable_type :string
#  commentable_id   :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#

class Comment < ActiveRecord::Base
  default_scope -> { order(id: :asc) }

  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :content, :user_id, :commentable_id, :commentable_type, presence: true

end
