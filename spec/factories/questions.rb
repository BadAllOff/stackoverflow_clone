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

FactoryGirl.define do

  factory :question do
    title 'This is Question title'
    body 'This is Question body'
    association(:user)
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    association(:user)
  end
end
