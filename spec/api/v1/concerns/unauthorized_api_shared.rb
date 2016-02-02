require 'rails_helper'

shared_examples_for "unauthorized api" do |request, method = :get|
  it 'returns 401 status if there is no access_token' do
    send method, request, format: :json
    expect(response.status).to eq 401
  end

  it 'returns 401 status if access_token is invalid' do
    send method, request, format: :json, access_token: '1234'
    expect(response.status).to eq 401
  end
end
