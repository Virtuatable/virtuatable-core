RSpec.describe do
  def app
    Controllers::Responses.new
  end

  describe :api_ok do
    before do
      get '/ok'
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(message: 'message')
    end
  end
  describe :api_list do
    before do
      get '/list'
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(
        count: 1,
        items: [{key: 'value'}]
      )
    end
  end
  describe :api_item do
    before do
      get '/item'
    end
    it 'Returns a 200 (OK) status code' do
      expect(last_response.status).to be 200
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(key: 'value')
    end
  end
  describe :api_created do
    before do
      get '/created'
    end
    it 'Returns a 201 (Created) status code' do
      expect(last_response.status).to be 201
    end
    it 'Returns the correct body' do
      expect(last_response.body).to include_json(key: 'value')
    end
  end
end