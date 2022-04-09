# frozen_string_literal: true

module Core
  module Models
    module Campaigns
      # A token represents an player or a monster in the game. It can be placed as a TokenPosition.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Token
        include Mongoid::Document
        include Mongoid::Timestamps

        store_in collection: 'tokens'

        # @!attribute [rw] name
        #   @return [String] the name of the token that will be displayed on the map
        field :name, type: String

        # @!attribute [rw] campaign
        #   @return [Core::Models::Campaign] the campaign in which this token can be used
        embedded_in :campaign, class_name: 'Core::Models::Campaign', inverse_of: :tokens
        # @!attribute [rw] creator
        #   @return [Core::Models::Account] the account of the player creating the token
        belongs_to :creator, class_name: 'Core::Models::Account', inverse_of: :tokens

        validates :name,
          presence: {message: 'required'},
          length: {minimum: 6, message: 'minlength', if: :name?}
      end
    end
  end
end