FactoryGirl.define do
  factory :question do
    title "Rails autoloading"
    body "How can I autoload a class defined in module?\nPlease, help!"

    factory :question_invalid do
      body ""
    end
  end

end
