FactoryGirl.define do
  factory :comment do
    user
    content "My comment text"
  end

  factory :invalid_comment, class: 'Comment'do
    user
    question
    content nil
  end
end
