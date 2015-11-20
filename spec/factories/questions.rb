FactoryGirl.define do
  factory :question do
    title "Rails autoloading"
    body "How can I autoload a class defined in module?\nPlease, help!"

    factory :question_invalid do
      body ""
    end

    factory :question_multi do
      sequence(:title) { |n| "Question ##{n}" }
      sequence(:body) { |n| "How can I solve problem ##{n}?" }
    end
  end

end
