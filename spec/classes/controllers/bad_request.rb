module Controllers
  class BadRequest < Core::Controllers::Base
    get '/method' do
      api_bad_request 'field.required'
    end
    get '/exception' do
      raise Core::Helpers::Errors::BadRequest.new(
        field: 'field',
        error: 'required'
      )
    end
  end
end