require 'rails_helper'

RSpec.describe 'Profile API', type: :request do
  describe 'GET /me' do
    it_behaves_like 'unauthorized api', '/api/v1/profiles/me'

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
      # По непонятной причине, если здесю заюзать шаред,
      # начинаются баги:
      # Expected equivalent JSON at path "updated_at"
      # -"2016-02-02T19:30:43.915+03:00"
      # +"2016-02-02T19:30:44.000+03:00"

      # it_behaves_like "json list", %w(id email created_at updated_at admin), :me, ""

      it_behaves_like "json path exclusion", %w(password encrypted_password), ""
    end
  end

  describe 'GET /' do
    it_behaves_like 'unauthorized api', '/api/v1/profiles'

    context 'authorized' do
      let (:me) { create(:user) }
      let!(:others) { create_list(:user_multi, 2) }
      let (:access_token) { create(:doorkeeper_access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'returns 200' do
        expect(response).to be_success
      end

      it 'returns list of other users' do
        expect(response.body).to have_json_size(2).at_path("profiles")
      end

      0.upto 1 do |i|
        it_behaves_like "json list", %w(id email created_at updated_at), :me, "profiles/#{i}/", false
        it_behaves_like "json path exclusion", %w(password encrypted_password), "profiles/#{i}/"
      end

      it 'contains all other users' do
        others.each do |user|
          expect(response.body).to include_json(user.to_json).at_path("profiles")
        end
      end
    end
  end
end
