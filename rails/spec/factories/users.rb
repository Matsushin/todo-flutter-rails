FactoryBot.define do
  factory :user do
    name { 'テストユーザ' }
    nickname { 'テストユーザ' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
  end
end
