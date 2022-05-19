RSpec.describe Core::Services::Sessions do
  let!(:service) { Core::Services::Sessions.instance }
  let!(:password) { 'long_password' }
  let!(:account) { create(:account, password: password, password_confirmation: password) }

  describe :create_from_credentials do
    it 'Returns the correct session if all informations are correct' do
      session = service.create_from_credentials(
        username: 'Babausse',
        password: password
      )
      expect(session.account.id.to_s).to eq account.id.to_s
    end
    it 'Fails if the username is not given' do
      params = { password: password }
      expect(->{ service.create_from_credentials(**params) }).to raise_error Core::Helpers::Errors::BadRequest
    end
    it 'Fails if the password is not given' do
      params = { username: account.username }
      expect(->{ service.create_from_credentials(**params) }).to raise_error Core::Helpers::Errors::BadRequest
    end
    it 'Fails if the user is not found' do
      params = {
        username: 'unknown',
        password: password
      }
      expect(->{ service.create_from_credentials(**params) }).to raise_error Core::Helpers::Errors::NotFound
    end
    it 'Fails if the password is wrong' do
      params = {
        username: account.username,
        password: 'wrong password'
      }
      expect(->{ service.create_from_credentials(**params) }).to raise_error Core::Helpers::Errors::Forbidden
    end
  end
  describe :get_by_id do
    let!(:session) { create(:session, account: account) }

    it 'Returns the session if it is correctly found' do
      result = service.get_by_id(session_id: session.token)
      expect(result.id.to_s).to eq session.id.to_s
    end
    it 'Fails if the session ID is not given' do
      expect(->{ service.get_by_id }).to raise_error Core::Helpers::Errors::BadRequest
    end
    it 'Fails if the session is not found' do
      expect(->{ service.get_by_id(username: 'unknown') }).to raise_error Core::Helpers::Errors::BadRequest
    end
  end
end