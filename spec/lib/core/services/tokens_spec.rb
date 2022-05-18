RSpec.describe Core::Services::Tokens do
  let!(:service) { Core::Services::Tokens.instance }
  let!(:account) { create(:account) }
  let!(:application) { create(:application, creator: account) }
  let!(:authorization) { create(:authorization, application: application) }

  describe :create_from_authorization do
    describe 'Nominal case' do
      let!(:token) {
        service.create_from_authorization(
          client_id: application.client_id,
          client_secret: application.client_secret,
          authorization_code: authorization.code
        )
      }
      it 'returns the created token if everything went as expected' do
        expect(token.id.to_s).to eq Core::Models::OAuth::AccessToken.first.id.to_s
      end
      it 'returns a token with the correct authorization code' do
        expect(token.authorization.id.to_s).to eq authorization.id.to_s
      end
      it 'returns a token without generator' do
        expect(token.generator).to be nil
      end
    end
    describe 'error cases' do
      it 'fails if the client ID is not given' do
        params = {
          client_secret: application.client_secret,
          authorization_code: authorization.code
        }
        expect(->{ service.create_from_authorization(**params) }).to raise_error Core::Helpers::Errors::BadRequest
      end
      it 'fails if the client secret is not given' do
        params = {
          client_id: application.client_id,
          authorization_code: authorization.code
        }
        expect(->{ service.create_from_authorization(**params) }).to raise_error Core::Helpers::Errors::BadRequest
      end
      it 'fails if the authorization code is not given' do
        params = {
          client_id: application.client_id,
          client_secret: application.client_secret
        }
        expect(->{ service.create_from_authorization(**params) }).to raise_error Core::Helpers::Errors::BadRequest
      end
      it 'fails if the client ID is unknown' do
        params = {
          client_id: 'unknown',
          client_secret: application.client_secret,
          authorization_code: authorization.code
        }
        expect(->{ service.create_from_authorization(**params) }).to raise_error Core::Helpers::Errors::NotFound
      end
      it 'fails if the authorization code is unknown' do
        params = {
          client_id: application.client_id,
          client_secret: application.client_secret,
          authorization_code: 'unknown'
        }
        expect(->{ service.create_from_authorization(**params) }).to raise_error Core::Helpers::Errors::NotFound
      end
      it 'fails if the authorization code does not belong to the application' do
        second_app = create(:application, creator: account, name: 'Second app')
        params = {
          client_id: second_app.client_id,
          client_secret: second_app.client_secret,
          authorization_code: authorization.code
        }
        expect(->{ service.create_from_authorization(**params) }).to raise_error Core::Helpers::Errors::BadRequest
      end
      it 'fails if the client secret does not match the application' do
        params = {
          client_id: application.client_id,
          client_secret: 'unknown',
          authorization_code: authorization.code
        }
        expect(->{ service.create_from_authorization(**params) }).to raise_error Core::Helpers::Errors::Forbidden
      end
      it 'fails if the authorization code has already been used' do
        second_auth = create(:authorization, application: application, code: 'any code', used: true)
        params = {
          client_id: application.client_id,
          client_secret: application.client_secret,
          authorization_code: second_auth.code
        }
        expect(->{ service.create_from_authorization(**params) }).to raise_error Core::Helpers::Errors::Forbidden
      end
    end
  end
  describe :create_from_token do
    let!(:generator) { create(:access_token, authorization: authorization) }

    describe 'nominal case' do
      let!(:token) {
        service.create_from_token(
          client_id: application.client_id,
          client_secret: application.client_secret,
          token: generator.value
        )
      }
      it 'returns the new token if everything goes as expected' do
        first_token = Core::Models::OAuth::AccessToken.order_by(created_at: :desc).first
        expect(token.id.to_s).to eq first_token.id.to_s
      end
      it 'returns a token with a generator' do
        expect(token.generator.id.to_s).to eq generator.id.to_s
      end
      it 'has set the generated token of the generator' do
        expect(generator.reload.generated.id.to_s).to eq token.id.to_s
      end
      it 'has no authorization code set' do
        expect(token.authorization.id.to_s).to eq authorization.id.to_s
      end
    end
    describe 'error cases' do
      it 'fails if the client_id is not given' do
        params = {
          client_secret: application.client_secret,
          token: generator.value
        }
        expect(->{ service.create_from_token(**params) }).to raise_error Core::Helpers::Errors::BadRequest
      end
      it 'fails if the client secret is not given' do
        params = {
          client_id: application.client_id,
          token: generator.value
        }
        expect(->{ service.create_from_token(**params) }).to raise_error Core::Helpers::Errors::BadRequest
      end
      it 'fails if the token value is not given' do
        params = {
          client_id: application.client_id,
          client_secret: application.client_secret
        }
        expect(->{ service.create_from_token(**params) }).to raise_error Core::Helpers::Errors::BadRequest
      end
      it 'fails if the client secret does not match the application' do
        params = {
          client_id: application.client_id,
          client_secret: 'unknown',
          authorization_code: generator.value
        }
        expect(->{ service.create_from_token(**params) }).to raise_error Core::Helpers::Errors::BadRequest
      end
      it 'fails if the token does not belong to the application' do
        second_app = create(:application, creator: account, name: 'Second app')
        params = {
          client_id: second_app.client_id,
          client_secret: second_app.client_secret,
          token: generator.value
        }
        expect(->{ service.create_from_token(**params) }).to raise_error Core::Helpers::Errors::BadRequest
      end
      it 'fails if the token has already been refreshed' do
        params = {
          client_id: application.client_id,
          client_secret: application.client_secret,
          token: generator.value
        }
        service.create_from_token(**params)
        expect(->{ service.create_from_token(**params) }).to raise_error Core::Helpers::Errors::Forbidden
      end
    end
  end
  describe :get_by_value do
    let!(:token) { create(:access_token, authorization: authorization) }

    it 'returns the token if everything goes as expected' do
      expect(service.get_by_value(token: token.value).id.to_s).to eq token.id.to_s
    end
    it 'fails if the token value is not given' do
      expect(->{ service.get_by_value }).to raise_error Core::Helpers::Errors::BadRequest
    end
    it 'fails if the token value is not found' do
      test_call = ->{ service.get_by_value(token: 'unknown') }
      expect(test_call).to raise_error Core::Helpers::Errors::NotFound
    end
  end
end