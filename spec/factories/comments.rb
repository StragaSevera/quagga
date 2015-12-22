FactoryGirl.define do
  factory :comment do
    user
    body "I'm helpful!!!"

    factory :comment_invalid do
      body ""
    end


    factory :comment_question do
      association :commentable, factory: :question
    end

    factory :comment_answer do
      association :commentable, factory: :question
    end
  end

end
