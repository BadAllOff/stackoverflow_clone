FactoryGirl.define do
  factory :comment do
    user
    content "MyText"
  end

  factory :invalid_comment, class: 'Comment'do
    user
    question
    content nil
  end
end
