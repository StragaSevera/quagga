require 'rails_helper'

shared_examples_for "b_cryptable" do
  it ".generate_token" do
    expect(SecureRandom).to receive(:urlsafe_base64)
    subject.class.generate_token
  end

  it ".generate_digest" do
    expect(BCrypt::Password).to receive(:create)
    subject.class.generate_digest("string")
  end

  it ".generate_digest" do
    expect(BCrypt::Password).to receive(:new)
    subject.class.check_token_match("string", "123")
  end
end