class QuestionSubscribersJob < ActiveJob::Base
  queue_as :default

  def perform(question, answer)
    question.subscriptions.find_each do |sub|
      MassNotificationMailer.question_subscribers(sub.user, question, answer).deliver_later
    end    
  end
end
