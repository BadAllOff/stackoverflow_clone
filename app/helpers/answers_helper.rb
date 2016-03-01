# == Schema Information
#
# Table name: answers
#
#  id           :integer          not null, primary key
#  body         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  question_id  :integer
#  user_id      :integer
#  best_answer  :boolean          default(FALSE)
#  rating_index :integer          default(0)
#

module AnswersHelper
end
