RSpec.describe Core::Services::Accounts do
  let!(:service) { Core::Services::Accounts.instance }
  let!(:account) { create(:account) }

  describe :get_by_username do
    describe 'Nominal case' do
      it 'Returns the correct account' do
        result = service.get_by_username(username: account.username)
        expect(result.id.to_s).to eq account.id.to_s
      end
    end
    describe 'Error cases' do
      it 'Fails if the username if not given' do
        expect(->{ service.get_by_username }).to raise_error(Core::Helpers::Errors::BadRequest)
      end
      it 'Fails if the username is not found' do
        params = {username: 'unknown'}
        expect(->{ service.get_by_username(**params) }).to raise_error(Core::Helpers::Errors::NotFound)
      end
    end
  end
  describe :get_by_credentials do
    describe 'Nominal case' do
      it 'Returns the correct account' do
        result = service.get_by_credentials(
          username: account.username,
          password: account.password
        )
        expect(result.id.to_s).to eq account.id.to_s
      end
    end
    describe 'Error cases' do
      it 'Fails if the username is not given' do
        params = { password: account.password }
        expect(->{ service.get_by_credentials }).to raise_error(Core::Helpers::Errors::BadRequest)
      end
      it 'Fails if the password is not given' do
        params = { username: account.username }
        expect(->{ service.get_by_credentials }).to raise_error(Core::Helpers::Errors::BadRequest)
      end
      it 'Fails if the username is not found' do
        params = {
          username: 'unknown',
          password: account.password
        }
        expect(->{ service.get_by_credentials(**params) }).to raise_error(Core::Helpers::Errors::NotFound)
      end
      it 'Fails if the password is wrong' do
        params = {
          username: account.username,
          password: 'wrong password'
        }
        expect(->{ service.get_by_credentials(**params) }).to raise_error(Core::Helpers::Errors::Forbidden)
      end
    end
  end
end