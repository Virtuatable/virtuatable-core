module Controllers
  class Forbidden < Core::Controllers::Base
    get '/method' do
      api_forbidden 'field.forbidden'
    end
    get '/exception' do
      raise Core::Helpers::Errors::Forbidden.new(
        field: 'field',
        error: 'forbidden'
      )
    end
  end
end