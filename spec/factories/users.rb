FactoryGirl.define do
  factory :user do
    id 1
    name 'John Smith'
    email 'john@example.org'
    password 'password'
    password_confirmation 'password'
    admin false

    initialize_with { User.find_or_create_by(id: id) }

    factory :user_invalid do
      id 2
      email nil
    end

    factory :user_multi do
      sequence(:id) { |n| 3+n }
      sequence(:name) { |n| "User ##{n}" }
      sequence(:email) { |n| "user#{n}@example.org" }
    end
  end

  factory :user_safe, class: User do
    sequence(:name) { |n| "Safe User ##{n}" }
    sequence(:email) { |n| "safe_user#{n}@example.org" }
    password 'password'
    password_confirmation 'password'
    admin false
  end
end
