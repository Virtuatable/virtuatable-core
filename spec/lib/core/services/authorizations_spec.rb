RSpec.describe Core::Services::Authorizations do
  let!(:service) { Core::Services::Authorizations.instance }
  let!(:account) { create(:account) }
  let!(:application) { create(:application, creator: account) }
  let!(:authorization) { create(:authorization, application: application) }

  describe :get_by_credentials do
    it 'returns the auth code when everything goes well' do
      params = {
        client_id: application.client_id,
        client_secret: application.client_secret,
        authorization_code: authorization.code
      }
      expect(service.get_by_credentials(**params).id.to_s).to eq authorization.id.to_s
    end
    it 'raises the correct error if the client ID is not given' do
      params = {
        client_secret: application.client_secret,
        authorization_code: authorization.code
      }
      expect(->{ service.get_by_credentials(**params) }).to raise_error Core::Helpers::Errors::BadRequest
    end
    it 'raises the correct error if the client secret is not given' do
      params = {
        client_id: application.client_id,
        authorization_code: authorization.code
      }
      expect(->{ service.get_by_credentials(**params) }).to raise_error Core::Helpers::Errors::BadRequest
    end
    it 'raises the correct error if the code value is not given' do
      params = {
        client_id: application.client_id,
        client_secret: application.client_secret
      }
      expect(->{ service.get_by_credentials(**params) }).to raise_error Core::Helpers::Errors::BadRequest
    end
    it 'raises the correct error if the client ID is not found' do
      params = {
        client_id: 'unknown',
        client_secret: application.client_secret,
        authorization_code: authorization.code
      }
      expect(->{ service.get_by_credentials(**params) }).to raise_error Core::Helpers::Errors::NotFound
    end
    it 'raises the correct error if the client secret does not match the client ID' do
      params = {
        client_id: application.client_id,
        client_secret: 'wrong secret',
        authorization_code: authorization.code
      }
      expect(->{ service.get_by_credentials(**params) }).to raise_error Core::Helpers::Errors::Forbidden
    end
    it 'raises the correct error if the code value is not found' do
      params = {
        client_id: application.client_id,
        client_secret: application.client_secret,
        authorization_code: 'wrong code'
      }
      expect(->{ service.get_by_credentials(**params) }).to raise_error Core::Helpers::Errors::NotFound
    end
    it 'raises the correct error if the authorization does not belong to the application' do
      second_app = create(:application, creator: account, name: 'Second app')
      second_auth = create(:authorization, application: second_app, code: SecureRandom.hex)
      params = {
        client_id: application.client_id,
        client_secret: application.client_secret,
        authorization_code: second_auth.code
      }
      expect(->{ service.get_by_credentials(**params) }).to raise_error Core::Helpers::Errors::BadRequest
    end
  end

  describe :get_by_code do
    it 'returns the auth code when everything goes well' do
      auth_code = service.get_by_code(authorization_code: authorization.code)
      expect(auth_code.id.to_s).to eq authorization.id.to_s
    end
    it 'raises the correct error if the code value is not given' do
      expect(->{ service.get_by_code }).to raise_error Core::Helpers::Errors::BadRequest
    end
    it 'raises the correct error if the code is not found' do
      expect(->{ service.get_by_code(authorization_code: 'unknown') }).to raise_error Core::Helpers::Errors::NotFound
    end
  end
end