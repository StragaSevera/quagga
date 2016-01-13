require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let!(:user) { create(:user) }
  before(:each) do 
    OmniAuth.config.test_mode = true 
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET #facebook" do
    before(:each) do
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        provider: 'facebook',
        uid: '123545',
        info: {
          email: user.email
        }
      })

      @request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    end

    it "assigns user to @user" do
      get :facebook
      expect(assigns(:user)).to eq user
    end

    it "signs in user" do
      get :facebook
      expect(subject.current_user).to eq user
    end

    it "redirects to root" do
      get :facebook
      expect(response).to redirect_to root_path
    end
  end
end
