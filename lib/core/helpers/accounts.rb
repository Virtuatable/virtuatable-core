# frozen_string_literal: true

module Core
  module Helpers
    # These helpers provide methods used to get and check accounts.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Accounts
      # Raises a bad request error if the account if not found.
      # @raise [Virtuatable::API::Errors::BadRequest] the error raised when the account is not found.
      def account
        return @account unless @account.nil?

        session_id_required if !respond_to?(:session) || session.nil?
        @account = session.account
      end

      def account_id_not_found
        api_bad_request('session_id.required')
      end
    end
  end
end
