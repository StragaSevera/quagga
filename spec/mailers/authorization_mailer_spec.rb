require "rails_helper"

RSpec.describe AuthorizationMailer, type: :mailer do
  describe "confirm_email" do
    let!(:user) {create(:user)}
    let!(:auth) {create(:authorization, user: user)}
    let(:mail) { AuthorizationMailer.confirm_email(auth, auth.activation_token) }

    it "renders the headers" do
      expect(mail.subject).to eq("Подтверждение адреса электронной почты")
      expect(mail.to).to eq([user.email])
    end

    it "renders the text body" do
      expect(mail.text_part.body.encoded).to include(auth.activation_token)
      expect(mail.text_part.body.encoded).to include(auth.id.to_s)
    end

    it "renders the html body" do
      expect(mail.html_part.body.encoded).to include(auth.activation_token)
      expect(mail.html_part.body.encoded).to include(auth.id.to_s)
    end
  end

end
