module Core
  module Decorators
    class Session < Core::Decorators::Base
      def to_h
        {
          token: token,
          account_id: account.id.to_s,
          created_at: created_at.iso8601
        }
      end
    end
  end
end