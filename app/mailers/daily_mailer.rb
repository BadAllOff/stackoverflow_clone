class DailyMailer < ApplicationMailer

  def digest(user)
    @greeting = 'Hi! Here is latest news, in case you missed them.'
    @questions = Question.where('created_at >= ?', Time.zone.now.beginning_of_day)

    mail to: user.email
  end
end
