FactoryGirl.define do
  factory :answer do
    body 'This is the Answer body'
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
