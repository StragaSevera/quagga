require "rails_helper"

RSpec.describe MassNotificationMailer, type: :mailer do
  let!(:user) {create(:user)}

  describe ".digest" do
    let!(:questions) { create_list(:question_multi, 3, user: user)}
    # Работаем не через массив, дабы выдать мейлеру именно тот формат,
    # который будет в продакшене
    let!(:question_not_to_send) { Question.first }
    let!(:questions_to_send) { Question.where.not(id: question_not_to_send.id) }
    let!(:mail) { MassNotificationMailer.digest(user, questions_to_send) }

    it "renders the headers" do
      expect(mail.subject).to eq("Дайджест свежих вопросов")
      expect(mail.to).to eq([user.email])
    end

    shared_examples_for "body rendering" do |part|
      it "renders the #{part.to_s}" do
        questions_to_send.each do |question|
          expect(mail.send(part).body.encoded).to include(question.title)
          expect(mail.send(part).body.encoded).to include(question_url(question.id))
        end
        expect(mail.send(part).body.encoded).not_to include(question_not_to_send.title)
        expect(mail.send(part).body.encoded).not_to include(question_url(question_not_to_send.id))
      end
    end

    it_behaves_like "body rendering", :text_part
    it_behaves_like "body rendering", :html_part
  end

  describe ".question_subscribers" do
    let!(:other) { create(:user_multi) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: other) }
    let!(:mail) { MassNotificationMailer.question_subscribers(user, question, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("На ваш вопрос \"#{question.title}\" дан новый ответ")
      expect(mail.to).to eq([user.email])
    end    

    # Т.к. учебный проект, игнорируем проблемы с новыми строками
    # и разницей html- и plain-шаблона. Они легко решаемы.
    shared_examples_for "body rendering" do |part|
      it "renders the #{part.to_s}" do
        expect(mail.send(part).body.encoded).to include(question.title)
        expect(mail.send(part).body.encoded).to include(question_url(question.id))
        expect(mail.send(part).body.encoded).to include(answer.body)
        expect(mail.send(part).body.encoded).to include(user.name)
        expect(mail.send(part).body.encoded).to include(other.name)
      end
    end

    it_behaves_like "body rendering", :text_part
    it_behaves_like "body rendering", :html_part
  end

end
