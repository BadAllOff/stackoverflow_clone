# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  username               :string
#  admin                  :boolean          default(FALSE)
#

FactoryGirl.define do

  sequence :email do |n|
    "user#{n}@test.com"
  end

  sequence :username do |n|
    "username #{n}"
  end

  factory :user do
    username
    email
    password '123456789'
    password_confirmation '123456789'

    factory :admin_user do
      admin true
    end

  end

end
