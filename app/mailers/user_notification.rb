class UserNotification < ApplicationMailer

  def new_answer_notification(user, answer)
    @answer = answer
    mail to: user.email
  end
end
