# Class to check if mongoid errors are caught and formatted
module Controllers
  class Mongoid < Core::Controllers::Base
    get '/exception' do
      # No username -> error
      Core::Models::Account.new(email: 'email.test.com').save!
    end
  end
end