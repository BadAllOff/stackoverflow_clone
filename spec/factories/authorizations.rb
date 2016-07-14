FactoryGirl.define do
  factory :authorization do
    user nil
    provider "Facebook"
    uid "123456"
  end
end
