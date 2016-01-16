FactoryGirl.define do
  factory :authorization do
    user nil
    provider "twitter"
    uid "123456"
    activated false
  end

end
