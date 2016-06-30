FactoryGirl.define do
  factory :comment do
    user
    content "MyText"
  end

  factory :invalid_comment, class: 'Comment'do
    user
    content nil
  end
end
