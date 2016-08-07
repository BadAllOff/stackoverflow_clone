require 'rails_helper'

RSpec.describe UserNotification, type: :mailer do
  describe 'new_answer_notification' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:mail) { UserNotification.new_answer_notification(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New answer notification')
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq(['from@example.com'])
    end
  end
end