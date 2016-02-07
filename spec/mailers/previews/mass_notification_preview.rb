# Preview all emails at http://localhost:3000/rails/mailers/mass_notification_mailer
class MassNotificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/mass_notification_mailer/digest
  # Пытался за-monkey-patch-ить превьюшер, увы, не вышло.
  # Так что делаем некрасиво.
  def digest
    ActiveRecord::Base.transaction do
      user = FactoryGirl.create(:user_safe)
      questions = FactoryGirl.create_list(:question_multi, 3, user: user)
      @mail = MassNotificationMailer.digest(user, questions[1..2])
      raise ActiveRecord::Rollback, "Тупой превьюшер не умеет сам откатывать данные =-("
    end
    @mail
  end

  def question_subscribers
    ActiveRecord::Base.transaction do
      user = FactoryGirl.create(:user_safe)
      other = FactoryGirl.create(:user_safe)
      question = FactoryGirl.create(:question, user_id: user.id)
      answer = FactoryGirl.create(:answer, question_id: question.id, user_id: other.id)
      @mail = MassNotificationMailer.question_subscribers(user, question, answer)
      raise ActiveRecord::Rollback, "Тупой превьюшер не умеет сам откатывать данные =-("
    end
    @mail
  end
end
