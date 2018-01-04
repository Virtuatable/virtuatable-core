module Arkaan
  module Authentication
    # A session represents the connection of the user on our frontend application. Nobody else than our frontend should
    # have access to the session or it's content (in particular to the token), instead they shall use the OAuth2.0 protocol.
    # A session shall ONLY be created by a premium application (only our frontend applications are premium).
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Session
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] token
      #   @return [String] the unique token for this session, used to identify it and be sure the user is connected on this application.
      field :token, type: String
      # @!attribute [rw] expiration
      #   @return [Integer] the time of expiration of the session, in seconds.
      field :expiration, type: Integer, default: 0

      # @!attribute [rw] account
      #   @return [Arkaan::Account] the account connected to the application.
      belongs_to :account, class_name: 'Arkaan::Account', inverse_of: :sessions

      validates :token,
        presence: {message: 'session.token.blank'},
        uniqueness: {message: 'session.token.uniq', if: :token?},
        length: {minimum: 10, message: 'session.token.short', if: :token?}

      validates :expiration,
        presence: {message: 'session.expiration.blank'}
    end
  end
end