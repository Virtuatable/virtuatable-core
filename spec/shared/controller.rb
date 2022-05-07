RSpec.shared_examples 'a controller' do |verb|
  let!(:klass) {
    Class.new(Core::Controllers::Base) do
      api_route verb, '/' do
        halt 200, 'foobar'
      end
      api_route verb, '/premium', options: {premium: true} do
        halt 200, 'foobar'
      end
    end
  }

  def app
    klass.new
  end

  let!(:account) { create(:account) }
  let!(:application) { create(:application, creator: account) }
  let!(:authorization) { create(:authorization, account: account, application: application) }
  let!(:token) { create(:access_token, authorization: authorization) }

  describe 'authenticated route' do
    describe 'Nominal case' do
      before do
        send(verb, "/", {token: token.value, client_id: application.client_id})
      end
      it 'Returns the expected body' do
        expect(last_response.body).to eq 'foobar'
      end
    end
    describe 'When the client ID is not given' do
      before do
        send(verb, "/", {token: token.value})
      end
      it 'Returns a 400 (Bad request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(field: 'client_id', error: 'required')
      end
    end
    describe 'When the client ID is not found' do
      before do
        send(verb, "/", {token: token.value, client_id: 'unknown'})
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(field: 'client_id', error: 'unknown')
      end
    end
    describe 'When the token is not given' do
      before do
        send(verb, "/", {client_id: application.client_id})
      end
      it 'Returns a 400 (Bad request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(field: 'token', error: 'required')
      end
    end
    describe 'When the token is not found' do
      before do
        send(verb, "/", {token: 'unknown', client_id: application.client_id})
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(field: 'token', error: 'unknown')
      end
    end
    describe 'When the token belongs to another application' do
      let!(:second_app) { create(:application, creator: account, name: 'Second app') }

      before do
        send(verb, "/", {token: token.value, client_id: second_app.client_id})
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(field: 'token', error: 'mismatch')
      end
    end
  end

  describe 'premium route' do
    let!(:premium) { create(:application, name: 'Premium app', creator: account, premium: true) }
    let!(:premium_auth) { create(:authorization, code: 'premium auth', account: account, application: premium) }
    let!(:premium_token) { create(:access_token, authorization: premium_auth, value: 'premium token') }

    describe 'Nominal case' do
      before do
        send(verb, "/premium", {token: premium_token.value, client_id: premium.client_id})
      end
      it 'Returns the expected body' do
        expect(last_response.body).to eq 'foobar'
      end
    end
    describe 'When the application is not a premium one' do
      before do
        send(verb, "/premium", {token: token.value, client_id: application.client_id})
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(field: 'client_id', error: 'forbidden')
      end
    end
  end
end