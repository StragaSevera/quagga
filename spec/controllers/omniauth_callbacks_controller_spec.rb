require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let!(:user) { create(:user) }
  before(:each) do 
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  shared_examples_for 'handles existing authorization' do |provider|

    before(:each) do
      OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
        provider: provider.to_s,
        uid: '123545',
        info: {
          email: user.email,
          name: "New Guy"
        }
      })

      @request.env["omniauth.auth"] = OmniAuth.config.mock_auth[provider]
    end

    it "assigns user to @user" do
      get provider
      expect(assigns(:user)).to eq user
    end

    it "signs in user" do
      get provider
      expect(subject.current_user).to eq user
    end

    it "redirects to root" do
      get provider
      expect(response).to redirect_to root_path
    end    
  end

  describe "GET #facebook" do
    it_behaves_like 'handles existing authorization', :facebook
  end

  describe "GET #twitter" do
    context "when assigned email" do
      it_behaves_like 'handles existing authorization', :twitter
    end

    context "when not assigned email" do
      before(:each) do
        OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
          provider: 'twitter',
          uid: '123545',
          info: {
            name: "New Guy"
          }
        })

        @request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      end

      it "does not assign user" do
        get :twitter
        expect(assigns(:user)).to be_nil
      end

      it "creates unactivated auth" do
        get :twitter
        expect(assigns(:unactivated_auth).uid).to eq @request.env["omniauth.auth"].uid
      end

      it "stores info in session" do
        get :twitter
        auth = assigns(:unactivated_auth)
        expect(session[:unactivated_auth]).to include(id: auth.id, token: auth.activation_token)
      end

      it "renders email prompt" do
        get :twitter
        expect(response).to render_template('omniauth_callbacks/prompt_email')
      end
    end
  end
end
