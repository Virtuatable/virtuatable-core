module Controllers
  class NotFound < Core::Controllers::Base
    get '/method' do
      api_not_found 'field.unknown'
    end
    get '/exception' do
      raise Core::Helpers::Errors::NotFound.new(
        field: 'field',
        error: 'unknown'
      )
    end
  end
end