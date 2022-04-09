# frozen_string_literal: true

module Core
  module Models
    module Campaigns
      # This is the instanciation of a token in one of the map of the campaign
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class TokenPosition
        include Mongoid::Document
        include Mongoid::Timestamps

        store_in collection: 'token_positions'

        # @!attribute [rw] x
        #   @return [Integer] the number of cells from the left before this token
        field :x, type: Integer, default: 0
        # @!attribute [rw] y
        #   @return [Integer] the number of cells from the top before this token
        field :y, type: Integer, default: 0

        # @!attribute [rw] map
        #   @return [Core::Models::Campaigns::Map] the map where this token is instanciated.
        embedded_in :map, class_name: 'Core::Models::Campaigns::Map', inverse_of: :positions

        # @!attribute [rw] token
        #   @return [Core::Models::Campaigns::Token] the source of the token, used to determine its appearance.
        belongs_to :token, class_name: 'Core::Models::Campaigns::Token', inverse_of: :positions

        validate :coordinates_bounds

        # Validates that the coordinates of the token position are in the map bounds.
        def coordinates_bounds
          errors.add(:x, 'bounds') if map.nil? or x < 0 or x >= map.width
          errors.add(:y, 'bounds') if map.nil? or y < 0 or y >= map.height
        end
      end
    end
  end
end
