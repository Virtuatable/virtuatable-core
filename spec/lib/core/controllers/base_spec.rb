RSpec.describe Core::Controllers::Base do

  describe 'Not Found errors' do
    def app
      Controllers::NotFound.new
    end
    describe 'raised with an exception' do
      before do
        get '/exception'
      end
      it 'Returns a 404 status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          status: 404,
          field: 'field',
          error: 'unknown'
        })
      end
    end
    describe 'halted with the method' do
      before do
        get '/method'
      end
      it 'Returns a 404 status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          status: 404,
          field: 'field',
          error: 'unknown'
        })
      end
    end
  end

  describe 'Forbidden errors' do
    def app
      Controllers::Forbidden.new
    end
    describe 'raised with an exception' do
      before do
        get '/exception'
      end
      it 'Returns a 403 status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          status: 403,
          field: 'field',
          error: 'forbidden'
        })
      end
    end
    describe 'halted with the method' do
      before do
        get '/method'
      end
      it 'Returns a 403 status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          status: 403,
          field: 'field',
          error: 'forbidden'
        })
      end
    end
  end

  describe 'Bad Request errors' do
    def app
      Controllers::BadRequest.new
    end
    describe 'raised with an exception' do
      before do
        get '/exception'
      end
      it 'Returns a 400 status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          status: 400,
          field: 'field',
          error: 'required'
        })
      end
    end
    describe 'halted with the method' do
      before do
        get '/method'
      end
      it 'Returns a 400 status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          status: 400,
          field: 'field',
          error: 'required'
        })
      end
    end
  end

  describe 'Mongoid errors' do
    def app
      Controllers::Mongoid.new
    end
    describe 'raised with an exception' do
      before do
        get '/exception'
      end
      it 'Returns a 400 status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          status: 400,
          field: 'username',
          error: 'required'
        })
      end
    end
  end

  describe 'Standard errors' do
    def app
      Controllers::StandardError.new
    end
    describe 'raised with an exception' do
      before do
        stub_const('ENV', {'RACK_ENV' => 'development'})
        get '/exception'
      end
      it 'Returns a 500 status code' do
        expect(last_response.status).to be 500
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          status: 500,
          field: 'unknown_field',
          error: 'StandardError'
        })
      end
    end
  end

  describe 'accounts helpers' do
    def app
      Controllers::Accounts.new
    end

    describe 'Nominal case' do
      let!(:account) { create(:account) }
      let!(:application) { create(:application, creator: account) }
      let!(:authorization) { create(:authorization, account: account, application: application) }
      let!(:token) { create(:access_token, authorization: authorization) }

      it 'should correctly return the account when asked' do
        get '/account', {token: token.value, client_id: application.client_id}
        expect(last_response.body).to include_json(id: account.id.to_s)
      end
    end
  end

  describe 'tokens helper' do
    def app
      Controllers::Tokens.new
    end

    let!(:account) { create(:account) }
    let!(:application) { create(:application, creator: account) }
    let!(:authorization) { create(:authorization, application: application) }
    let!(:token) { create(:access_token, authorization: authorization) }

    describe 'Nominal case' do
      it 'returns the correct body' do
        get '/tokens', {token: token.value, client_id: application.client_id}
        expect(last_response.body).to include_json(id: token.id.to_s)
      end
    end
    describe 'When the client UUID of the application is not given' do
      before do
        get '/tokens', {token: token.value}
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(field: 'client_id', error: 'required')
      end
    end
    describe 'When the client UUID of the application does not exist' do
      before do
        get '/tokens', {token: token.value, client_id: 'unknown'}
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
        get '/tokens', {client_id: application.client_id}
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(field: 'token', error: 'required')
      end
    end
    describe 'When the token does not exist' do
      before do
        get '/tokens', {token: 'unknown', client_id: application.client_id}
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(field: 'token', error: 'unknown')
      end
    end
    describe 'When token does not belong to the provided application' do
      let!(:second_app) { create(:application, name: 'Second application') }

      before do
        get '/tokens', {token: token.value, client_id: second_app.client_id}
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(field: 'token', error: 'mismatch')
      end
    end
  end

  describe 'fields helpers' do
    describe :check_either_presence do
      def app
        Controllers::Fields.new
      end
      describe 'Nominal case' do
        it 'Returns a 200 (OK) status code' do
          get '/fields', {key: 'value'}
          expect(last_response.status).to be 200
        end
      end
      describe 'When none of the fields are given' do
        before do
          get '/fields'
        end
        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            status: 400,
            field: 'custom_label',
            error: 'required'
          )
        end
      end
    end
  end

  describe :params do
    def app
      Controllers::Parameters.new
    end
    describe 'From a query with JSON body' do
      before do
        post '/body/1', {key: 'value'}.to_json
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: '1',
          key: 'value'
        )
      end
    end
    describe 'From a query with a querystring' do
      before do
        get '/querystring/1', {key: 'value'}
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: '1',
          key: 'value'
        )
      end
    end
    describe 'From a query with both' do
      before do
        post '/both/1?foo=bar', {key: 'value'}.to_json
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          id: '1',
          foo: 'bar',
          key: 'value'
        )
      end
    end
  end

  describe 'API routes' do
    it_should_behave_like 'a controller', 'get'
  end
end