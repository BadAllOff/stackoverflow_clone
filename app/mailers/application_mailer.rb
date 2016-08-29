class ApplicationMailer < ActionMailer::Base
  append_view_path Rails.root.join('app', 'views', 'mailers')
  default from: 'from@example.com' # Rails.application.secrets.default_email
  layout 'mailer'
end
