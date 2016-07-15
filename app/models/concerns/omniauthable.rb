module Omniauthable
  extend ActiveSupport::Concern

  included do

    has_many :authorizations

    def self.find_for_oauth(auth)
      return if auth.nil? || auth.empty?
      return if auth.provider.nil? || auth.uid.nil?
      return if auth.provider.empty? || auth.uid.empty?

      authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authorization.user if authorization

      auth.info.try(:email) ? (email = auth.info[:email]) : (return nil)

      user = User.where(email: email).first

      auth.info.try(:name) ? (username = auth.info[:name]) : (username = 'New User')
      username = username + rand(100000).to_s if User.where(username: username).present?

      if user
        user.create_authorization(auth)
      else
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, username: username, password: password, password_confirmation: password)
        if user.save
          user.create_authorization(auth)
        else
          return nil
        end
      end

      user
    end

    def create_authorization(auth)
      self.authorizations.create(provider: auth.provider, uid: auth.uid)
    end
  end
end