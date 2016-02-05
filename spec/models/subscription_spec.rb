require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
end
