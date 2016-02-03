FactoryGirl.define do
  sequence :body do |n|
    "This is the Answer body #{n}"
  end
  factory :answer do
    body 'This is the Answer body'
    user
    question
  end

  factory :random_answer do
    body
    user
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    user
    question
  end
end
