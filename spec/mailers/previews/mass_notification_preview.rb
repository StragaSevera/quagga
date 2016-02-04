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
end
