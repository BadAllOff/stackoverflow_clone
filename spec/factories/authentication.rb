FactoryGirl.define do
  factory :authentication do
    user nil
    provider "Facebook"
    uid "123456"
  end
end
