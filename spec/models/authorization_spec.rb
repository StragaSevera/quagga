require 'rails_helper'

RSpec.describe Authorization, type: :model do  
  context "with validations" do
    it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }
    it { should validate_presence_of :activated }

    it { should belong_to(:user) }
  end
end
