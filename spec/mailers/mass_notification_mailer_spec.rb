require "rails_helper"

RSpec.describe MassNotificationMailer, type: :mailer do
  describe "digest" do
    let!(:user) {create(:user)}
    let!(:questions) { create_list(:question_multi, 3, user: user)}
    # Работаем не через массив, дабы выдать мейлеру именно тот формат,
    # который будет в продакшене
    let!(:question_not_to_send) { Question.first }
    let!(:questions_to_send) { Question.where.not(id: question_not_to_send.id) }
    let(:mail) { MassNotificationMailer.digest(user, questions_to_send) }

    it "renders the headers" do
      expect(mail.subject).to eq("Дайджест свежих вопросов")
      expect(mail.to).to eq([user.email])
    end

    it "renders the text body" do
      questions_to_send.each do |question|
        expect(mail.text_part.body.encoded).to include(question.title)
        expect(mail.text_part.body.encoded).to include(question_url(question.id))
      end
      expect(mail.text_part.body.encoded).not_to include(question_not_to_send.title)
      expect(mail.text_part.body.encoded).not_to include(question_url(question_not_to_send.id))
    end

    it "renders the html body" do
      questions_to_send.each do |question|
        expect(mail.html_part.body.encoded).to include(question.title)
        expect(mail.html_part.body.encoded).to include(question_url(question.id))
      end
      expect(mail.html_part.body.encoded).not_to include(question_not_to_send.title)
      expect(mail.html_part.body.encoded).not_to include(question_url(question_not_to_send.id))
    end
  end

end
