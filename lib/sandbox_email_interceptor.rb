# config/initializers/email.rb
class SandboxEmailInterceptor
  def self.delivering_email(email)
    email.subject = "#{email.subject} (to: #{email.to})"
    email.to = ['sandbox@example.com']
  end
end