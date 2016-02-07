require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:users) { create_list(:user_multi, 2) }
  let!(:questions) { create_list(:question_multi, 2, user: users.first) }

  it 'sends daily digest' do
    expect(Question).to receive(:digest).and_return(questions)

    users.each do |user|
      expect(MassNotificationMailer).to receive(:digest).with(user, questions).and_call_original
    end

    DailyDigestJob.perform_now
  end
end
