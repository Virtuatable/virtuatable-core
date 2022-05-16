RSpec.describe Core::Services::Applications do
  let!(:service) { Core::Services::Applications.instance }
  let!(:account) { create(:account) }
  let!(:application) { create(:application, creator: account) }

  describe :get_by_credentials do
    it 'returns the application if everything is right' do
      app = service.get_by_credentials(
        client_id: application.client_id,
        client_secret: application.client_secret
      )
      expect(app.id.to_s).to eq application.id.to_s
    end
    it 'raises the correct error if the application is not found' do
      params = { client_id: 'unknown', client_secret: application.client_secret }
      expect(->{ service.get_by_credentials(**params) }).to raise_error(Core::Helpers::Errors::NotFound)
    end
    it 'raises the correct error if the application does not match the client secret' do
      params = { client_id: application.client_id, client_secret: 'unknown' }
      expect(->{ service.get_by_credentials(**params) }).to raise_error(Core::Helpers::Errors::Forbidden)
    end
    it 'raises the correct error if the client ID is not given' do
      params = { client_secret: application.client_secret }
      expect(->{ service.get_by_credentials(**params) }).to raise_error(Core::Helpers::Errors::BadRequest)
    end
    it 'raises the correct error if the client secret is not given' do
      params = { client_id: application.client_id }
      expect(->{ service.get_by_credentials(**params) }).to raise_error(Core::Helpers::Errors::BadRequest)
    end
  end

  describe :get_by_id do
    it 'returns the application if everything is right' do
      expect(service.get_by_id(client_id: application.client_id).id.to_s).to eq application.id.to_s
    end
    it 'raises the correct error if the application is not found' do
      expect(->{ service.get_by_id(client_id: 'unknown') }).to raise_error(Core::Helpers::Errors::NotFound)
    end
    it 'raises the correct error if the client ID is not given' do
      expect(->{ service.get_by_id }).to raise_error(Core::Helpers::Errors::BadRequest)
    end
  end
end