class DailyMailer < ApplicationMailer

  def digest(user)
    @greeting = 'Hi! Here is latest news, in case you missed them.'

    mail to: user.email
  end
end
