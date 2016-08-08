require 'rails_helper'

RSpec.describe Answer, type: :model do

  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let!(:answers) { create_list(:answer, 5, question: question, best_answer: true) }

  describe 'Associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
    it { should have_many(:attachments).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe 'Validations' do
    it { should validate_presence_of :body }
    it { should accept_nested_attributes_for :attachments }
  end

  describe '#set_best' do
    it 'sets #best to true' do
      answer.set_best
      answer.reload
      expect(answer).to be_best_answer
    end

    it 'sets #best to false for the rest answers' do
      answer.set_best
      answers.each do |ans|
        ans.reload
        expect(ans).to_not be_best_answer
      end
    end
  end
end
