# Preview all emails at http://localhost:3000/rails/mailers/user_notification
class UserNotificationPreview < ActionMailer::Preview
  def new_answer_notification
    UserNotification.new_answer_notification(User.first, Answer.first)
  end
end
