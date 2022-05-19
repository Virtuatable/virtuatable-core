RSpec.describe Core::Services::Authorizations do
  let!(:service) { Core::Services::Authorizations.instance }
  let!(:account) { create(:account) }
  let!(:application) { create(:application, creator: account) }
  let!(:authorization) { create(:authorization, application: application) }

  describe :create_from_credentials do
    let!(:session) { create(:session, account: account) }

    describe 'Nominal case' do
      let!(:created) {
        service.create_from_session(
          session_id: session.token,
          client_id: application.client_id
        )
      }
      it 'Created only one authorization' do
        expect(Core::Models::OAuth::Authorization.where(code: created.code).count).to be 1
      end
      it 'has the correct application linked to it' do
        expect(created.application.id.to_s).to eq application.id.to_s
      end
      it 'has the correct account linked to it' do
        expect(created.account.id.to_s).to eq account.id.to_s
      end
    end
    describe 'Error cases' do

      it 'Fails if the session ID is not given' do
        params = {
          client_id: application.client_id
        }
        expect(->{ service.create_from_session(**params) }).to raise_error Core::Helpers::Errors::BadRequest
      end
      it 'Fails if the client ID is not given' do
        params = {
          session_id: session.token
        }
        expect(->{ service.create_from_session(**params) }).to raise_error Core::Helpers::Errors::BadRequest
      end
      it 'Fails if the client ID does not exist' do
        params = {
          client_id: 'unknown',
          session_id: session.token
        }
        expect(->{ service.create_from_session(**params) }).to raise_error Core::Helpers::Errors::NotFound
      end
      it 'Fails if the session ID does not exist' do
        params = {
          client_id: application.client_id,
          session_id: 'unknown'
        }
        expect(->{ service.create_from_session(**params) }).to raise_error Core::Helpers::Errors::NotFound
      end
    end
  end

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