module Core
  module Decorators
    class Account < Core::Decorators::Base
      def has_password?(password)
        BCrypt::Password.new(object.password_digest) == password
      end
    end
  end
end