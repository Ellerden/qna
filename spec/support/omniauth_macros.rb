module OmniauthMacros
  def mock_auth_hash(provider, email = 'mockuser@test.com')
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      provider: provider,
      uid: '123545',
      info: {
        name: 'mockuser',
        email: email
      }
    })
  end
end
