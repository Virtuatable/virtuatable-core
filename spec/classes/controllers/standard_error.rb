module Controllers
  class StandardError < Core::Controllers::Base
    get '/exception' do
      raise ::StandardError.new
    end
  end
end