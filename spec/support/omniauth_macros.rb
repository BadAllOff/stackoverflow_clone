
module OmniauthMacros

  def mock_auth_hash(provider)
    if(provider == :facebook)
      hash = OmniAuth::AuthHash.new({
                                        provider: provider.to_s,
                                        uid: '123456',
                                        info: { email: 'test@mail.com', name: 'User Name' }
                                    })
    else
      hash = OmniAuth::AuthHash.new({
                                        provider: provider.to_s,
                                        uid: '123456',
                                        info: {}
                                    })
    end
    OmniAuth.config.mock_auth[provider] = hash
  end

end