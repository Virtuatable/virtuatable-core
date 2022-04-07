module Controllers
  class Responses < Sinatra::Base
    include Core::Helpers::Responses

    get '/created' do
      api_created key: 'value'
    end
    get '/ok' do
      api_ok 'message'
    end
    get '/item' do
      api_item key: 'value'
    end
    get '/list' do
      api_list [{key: 'value'}]
    end
  end
end
