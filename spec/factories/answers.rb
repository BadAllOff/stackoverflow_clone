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
