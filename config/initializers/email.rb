# lib/sandbox_email_interceptor.rb
require 'sandbox_email_interceptor'
unless Rails.env.production?
  ActionMailer::Base.register_interceptor(SandboxEmailInterceptor)
end