class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    questions = Question.digest
    User.find_each.each do |user|
      mail = MassNotificationMailer.digest(user, questions)
      mail.deliver_now
    end
  end
end