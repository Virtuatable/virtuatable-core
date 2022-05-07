module Controllers
  class Tokens < Core::Controllers::Base
    get '/tokens' do
      halt 200, {id: token.id.to_s}.to_json
    end
  end
end