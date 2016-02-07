require 'rails_helper'

RSpec.describe QuestionSubscribersJob, type: :job do
  let!(:users) { create_list(:user_multi, 3) }
  let!(:question) { create(:question, user: users.first) }
  let!(:answer) { create(:answer, question: question, user: users.second) }
  before(:each) { users.each { |user| user.subscribe_to(question) } }

  it 'sends question notifications' do
    users.each do |user|
      expect(MassNotificationMailer).to receive(:question_subscribers).with(user, question, answer).and_call_original
    end

    QuestionSubscribersJob.perform_now(question, answer)
  end
end
