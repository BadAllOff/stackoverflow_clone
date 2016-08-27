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

FactoryGirl.define do

  factory :comment do
    content 'My comment text'
    user
  end

  factory :invalid_comment, class: 'Comment'do
    user
    content nil
  end
end
