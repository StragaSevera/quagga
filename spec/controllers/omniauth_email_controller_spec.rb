require 'rails_helper'

RSpec.describe OmniauthEmailController, type: :controller do
  let!(:user) { create(:user) }
  
  describe "POST #handle_email" do
    context "when empty session" do
      it "redirects to root" do
        post :handle_email
        expect(response).to redirect_to root_path
      end
    end

    context "when correct session" do
      context "and wrong id" do
        it "redirects to root" do
          post :handle_email, nil, {unactivated_auth: {"id" => -2}}
          expect(response).to redirect_to root_path
        end        
      end

      context "and right id" do
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

        let!(:unactivated_auth) { Authorization.create_unactivated(@request.env["omniauth.auth"]) }

        it "assigns user to @user" do
          get :handle_email, {auth: {email: user.email}}, {unactivated_auth: {"id" => unactivated_auth.id, "token" => unactivated_auth.activation_token}}
          expect(assigns(:user)).to eq user
        end

        it "sends email to user" do
          expect do
            get(:handle_email, {auth: {email: user.email}}, {unactivated_auth: {"id" => unactivated_auth.id, "token" => unactivated_auth.activation_token}})
          end.to change(ActionMailer::Base.deliveries, :count).by 1
        end

        it "redirects to root" do
          get :handle_email, {auth: {email: user.email}}, {unactivated_auth: {"id" => unactivated_auth.id, "token" => unactivated_auth.activation_token}}
          expect(response).to redirect_to root_path
        end   
      end
    end
  end

  describe "GET #confirm_email" do
    let!(:auth) {create(:authorization, user: user)}

    it "finds correct auth" do
      get :confirm_email, id: auth.id, token: auth.activation_token
      expect(assigns(:auth)).to eq auth
    end

    it "signs in correct user" do
      get :confirm_email, id: auth.id, token: auth.activation_token
      expect(subject.current_user).to eq user
    end

    it "does not sign in user on token mismatch" do
      get :confirm_email, id: auth.id, token: "123456"
      expect(subject.current_user).not_to eq user
    end

    it "activates authorization" do
      get :confirm_email, id: auth.id, token: auth.activation_token
      expect(auth.reload).to be_activated
    end

    it "does not activate user on token mismatch" do
      get :confirm_email, id: auth.id, token: "123456"
      expect(auth.reload).not_to be_activated
    end
  end
end
