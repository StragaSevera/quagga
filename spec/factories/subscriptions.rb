FactoryGirl.define do
  factory :subscription do
    association :user, factory: :user_multi
    question
  end

end
