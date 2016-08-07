class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com' # Rails.application.secrets.default_email
  layout 'mailer'
end
