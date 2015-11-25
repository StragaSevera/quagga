FactoryGirl.define do
  factory :user do
    name 'John Smith'
    email 'john@example.org'
    password 'password'
    password_confirmation 'password'

    factory :user_invalid do
      email nil
    end

    factory :user_multi do
      sequence(:name) { |n| "User ##{n}" }
      sequence(:email) { |n| "user#{n}@example.org" }
    end
  end
end
