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
