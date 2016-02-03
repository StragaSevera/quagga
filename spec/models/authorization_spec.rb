require 'rails_helper'

RSpec.describe Authorization, type: :model do  
  let(:authorization) { create(:authorization) }
  let(:user) { create(:user) }

  it_behaves_like "b_cryptable"

  context "with validations" do
    it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }

    it { should belong_to(:user) }
  end

  describe '.create_from_hash' do
    let (:user) { create(:user) }
    let!(:auth_hash) do
      OmniAuth::AuthHash.new({
        provider: 'twitter',
        uid: '123545',
        info: {
          name: "New Guy",
          email: user.email
        }
      })
    end

    it "correctly fills fields" do
      auth = Authorization.create_from_hash(auth_hash, true, user)
      expect(auth.provider).to eq auth_hash.provider
      expect(auth.uid).to eq auth_hash.uid
      expect(auth.name).to eq auth_hash[:info].name
      expect(auth.user).to eq user
      expect(auth).to be_activated
    end

    it "correctly handles tokens" do
      auth = Authorization.create_from_hash(auth_hash, true, user)
      expect(auth.token_matches?(auth.activation_token)).to be_truthy
    end
  end

  describe '.create_unactivated' do
    let!(:auth_hash) do
      OmniAuth::AuthHash.new({
        provider: 'twitter',
        uid: '123545',
        info: {
          name: "New Guy"
        }
      })
    end

    it "correctly fills fields" do
      auth = Authorization.create_unactivated(auth_hash)
      expect(auth.provider).to eq auth_hash.provider
      expect(auth.uid).to eq auth_hash.uid
      expect(auth.name).to eq auth_hash[:info].name
      expect(auth).not_to be_activated
    end
  end

  describe '#connect_by_user' do
    it "connects by user" do
      expect(authorization.connect_by_user(user)).to eq user
      expect(authorization.user).to eq user
    end

    it "do not connect by nil" do
      expect(authorization.connect_by_user(nil)).to eq false
      expect(authorization.user).to eq nil
    end
  end

  describe '#connect_by_email' do
    it "connects by email" do
      expect(authorization.connect_by_email(user.email)).to eq user
      expect(authorization.user).to eq user
    end
  end
end
