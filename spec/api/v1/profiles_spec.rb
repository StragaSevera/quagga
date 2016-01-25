require 'rails_helper'

RSpec.describe 'Profile API', type: :request do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 if no access token' do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 if invalid access token' do
        get '/api/v1/profiles/me', format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let (:me) { create(:user) }
      let (:access_token) { create(:doorkeeper_access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns 200' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attribute|
        it "contains #{attribute}" do
          expect(response.body).to be_json_eql(me.send(attribute.to_sym).to_json).at_path(attribute)
        end
      end

      %w(password encrypted_password).each do |attribute|
        it "does not contain #{attribute}" do
          expect(response.body).to_not have_json_path(attribute)
        end
      end
    end
  end

  describe 'GET /' do
    context 'unauthorized' do
      it 'returns 401 if no access token' do
        get '/api/v1/profiles', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 if invalid access token' do
        get '/api/v1/profiles', format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let (:me) { create(:user) }
      let!(:others) { create_list(:user_multi, 2) }
      let (:access_token) { create(:doorkeeper_access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'returns 200' do
        expect(response).to be_success
      end

      it 'does not contain me' do
        expect(response.body).not_to include_json(me.to_json)
      end

      %w(password encrypted_password).each do |attribute|
        it "does not contain #{attribute}" do
          expect(response.body).to_not have_json_path(attribute)
        end
      end

      it 'contains all other index' do
        others.each do |user|
          expect(response.body).to include_json(user.to_json)
        end
      end
    end
  end
end
