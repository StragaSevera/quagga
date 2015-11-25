FactoryGirl.define do
  factory :question do
    user
    title "Rails autoloading"
    body "How can I autoload a class defined in module?\nPlease, help!"

    factory :question_invalid do
      body ""
    end

    factory :question_multi do
      sequence(:title) { |n| "##{n} question " }
      sequence(:body) { |n| "How can I solve ##{n} problem?" }
    end
  end
end
