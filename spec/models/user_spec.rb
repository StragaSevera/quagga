require 'rails_helper'

RSpec.describe User, type: :model do
  let (:user) { build(:user) }

  context "with validations" do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_least(2).is_at_most 30 }

    it { should validate_presence_of :email }
    it { should validate_length_of(:email).is_at_least(2).is_at_most 200 }

    it { should validate_presence_of :password }  
    it { should validate_length_of(:password).is_at_least(4).is_at_most 200 }

    it { should have_many(:questions) } 
    it { should have_many(:answers) } 
  end
end