# frozen_string_literal: true

module Core
  module Models
    module Campaigns
      # A map is a battleground where the players can place tokens and live the adventure.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Map
        include Mongoid::Document
        include Mongoid::Timestamps

        store_in collection: 'maps'

        # @!attribute [rw] height
        #   @return [Integer] the number of lines in the map matric.
        field :height, type: Integer, default: 1
        # @!attribute [rw] width
        #   @return [Integer] the number of columns in the map matric.
        field :width, type: Integer, default: 1

        # @!attribute [rw] campaign
        #   @return [Core::Models::Campaign] the campaign in which the map can be found.
        belongs_to :campaign, class_name: 'Core::Models::Campaign', inverse_of: :maps

        # @!attribute [rw] positions
        #   @return [Array<Core::Model::Campaigns::TokenPosition>] the instanciated tokens on this map.
        embeds_many :positions, class_name: 'Core::Models::Campaigns::TokenPosition', inverse_of: :map

        validates :height,
          numericality: { greater_than: 0, message: 'minimum' }
        
        validates :width,
          numericality: { greater_than: 0, message: 'minimum' }
      end
    end
  end
end
