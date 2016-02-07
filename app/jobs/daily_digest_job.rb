class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    questions = Question.digest
    User.find_each do |user|
      mail = MassNotificationMailer.digest(user, questions)
      mail.deliver_later
    end
  end
end