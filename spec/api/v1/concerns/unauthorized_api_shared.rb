require 'rails_helper'

shared_examples_for "unauthorized api" do |request|
  it 'returns 401 status if there is no access_token' do
    get request, format: :json
    expect(response.status).to eq 401
  end

  it 'returns 401 status if access_token is invalid' do
    get request, format: :json, access_token: '1234'
    expect(response.status).to eq 401
  end
end
