FactoryGirl.define do
  factory :answer do
    user
    question
    # Внезапно появилась проблема с мылом в данном случае.
    # Чтобы не расписывать кучу разных преобразований новой строки
    # и кавычек, для простоты ее убираю. Можно было бы оставить
    # и обработать в спеке... но это легко (вызываем simple_format) и потому неинтересно =-)
    body "If you can unwrap it from the module, simply place it at app/something/class.rb. Hope this helps."
    
    factory :answer_invalid do
      body ""
    end

    factory :answer_multi do
      sequence(:body) { |n| "##{n} problem solved!" }
    end

    # Применяем извращения, NC17
    # Открываем eigenclass для вновь созданного объекта
    # и заменяем метод send_email_to_subscribers заглушкой,
    # чтобы он не мешался, за исключением моментов, когда нужен
    after(:build) { |answer| 
      class << answer
        def send_email_to_subscribers; true; end
      end
    }

    trait :with_email do
      after(:build) { |answer| 
        class << answer
          def send_email_to_subscribers; super; end
        end
      }
    end
  end

end
