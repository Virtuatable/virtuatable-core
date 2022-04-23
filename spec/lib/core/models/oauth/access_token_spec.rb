RSpec.describe Core::Models::OAuth::AccessToken do
  describe :value do
    it 'returns the right value for a built token' do
      expect(build(:access_token).value).to eq 'test_access_token'
    end
    it 'invalidates the access token if the value is not given' do
      expect(build(:access_token, value: nil).valid?).to be false
    end
    it 'invalidates the access token if the value is already existing' do
      create(:access_token, authorization: create(:authorization))
      expect(build(:access_token).valid?).to be false
    end
    it 'generates a default random value for the token value' do
      expect(build(:random_access_token).value.size).to be 32
    end
  end

  describe :expiration do
    it 'returns the expiration delay in seconds for a build token' do
      expect(build(:random_expiration_token).expiration).to be 86400
    end
    it 'generates a default random value for the expiration delay' do
      expect(build(:access_token).expiration).to be 3600
    end
  end

  describe :authorization do
    it 'returns the right authorization for a built access token' do
      expect(create(:access_token, authorization: create(:authorization)).authorization.code).to eq 'test_code'
    end
    it 'invalidates the access token if the authorization is not given' do
      expect(build(:access_token, authorization: nil).valid?).to be false
    end
  end

  describe 'Premium tokens' do
    let!(:account) { create(:account) }
    let!(:application) { create(:application, premium: true, creator: account) }
    let!(:scope) { create(:scope) }
    let!(:authorization) { create(:authorization, application: application, account: account) }
    let!(:token) { create(:access_token, authorization: authorization, expiration: 0) }

    it 'is considered premium' do
      expect(token.premium?).to be true
    end
    it 'can never expire' do
      expect(token.expired?).to be false
    end
    it 'has all the scopes' do
      expect(token.scopes).to eq [scope]
    end
  end
end