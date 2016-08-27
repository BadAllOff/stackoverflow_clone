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

FactoryGirl.define do

  factory :answer do
    body 'This is the Answer body'
    user
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    user
    question
  end
end
