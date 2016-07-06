FactoryGirl.define do
  factory :comment do
    content "My comment text"
    user
  end

  factory :invalid_comment, class: 'Comment'do
    user
    content nil
  end
end
