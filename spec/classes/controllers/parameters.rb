module Controllers
  class Parameters < Core::Controllers::Base
    post '/body/:id' do
      halt 200, params.to_json
    end
    get '/querystring/:id' do
      halt 200, params.to_json
    end
    post '/both/:id' do
      halt 200, params.to_json
    end
  end
end