RSpec.describe Core::Services::Sessions do
  let!(:service) { Core::Services::Sessions.new }

  describe :create do
    it 'Fails if the user is not found' do
      expect { service.create('test', 'test_password') }.to raise_error(
        Core::Helpers::Errors::NotFound
      )
    end
    it 'Fails if the user has provided the wrong password' do
      create(:account, username: 'Babausse')
      expect { service.create('Babausse', 'wrong_password') }.to raise_error(
        Core::Helpers::Errors::Forbidden
      )
    end
    it 'Creates a session if all informations are correct' do
      create(:account, username: 'Babausse')
      session = service.create('Babausse', 'password')
      expect(session.token).to match /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    end
  end
end