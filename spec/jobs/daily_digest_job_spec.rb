require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:users) { create_list(:user_multi, 2) }
  let!(:questions) { create_list(:question_multi, 2, user: users.first) }

  # Стоит ли разбивать на несколько тестов?..
  it 'sends daily digest' do
    expect(Question).to receive(:digest).and_call_original

    users.each do |user|
      # Решил не городить проверку с satisfy, и не проверять актуальность
      # дайджеста - все равно она проверяется в спеке скоупа
      expect(MassNotificationMailer).to receive(:digest).with(user, any_args).and_call_original
    end

    DailyDigestJob.perform_now
  end
end
