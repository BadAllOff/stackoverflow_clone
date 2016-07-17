module Omniauthable
  extend ActiveSupport::Concern

  included do

    has_many :authentication

    def self.find_for_oauth(auth)
      return if auth.nil? || auth.empty?
      return if auth.provider.nil? || auth.uid.nil?
      return if auth.provider.empty? || auth.uid.empty?

      authentication = Authentication.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authentication.user if authentication
      auth.info.try(:email) ? (email = auth.info[:email]) : email = nil
      auth.info.try(:name) ? (username = auth.info[:name]) : username = nil
      user = User.where('lower(email) = ?', email.downcase).first if email

      if user
        user.create_authentication(auth)
      else
        password = Devise.friendly_token[0, 20]
        user = User.create(email: email, username: username, password: password, password_confirmation: password)
        if user.save
          user.create_authentication(auth)
        else
        end
      end

      user
    end

    def create_authentication(auth)
      self.authentication.create(provider: auth.provider, uid: auth.uid)
    end
  end
end