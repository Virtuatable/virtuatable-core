module Core
  module Services
    class Accounts < Core::Services::Base
      def get_by_username(username)
        account = Core::Models::Account.find_by(username: username)
        if account.nil?
          raise Core::Helpers::Errors::NotFound.new(
            field: 'username',
            error: 'unknown'
          )
        end
        account
      end
    end
  end
end