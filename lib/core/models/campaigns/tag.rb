# frozen_string_literal: true

module Core
  module Models
    module Campaigns
      # A campaign tag is a string describing a characteristic of the campaign it's in.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Tag
        include Mongoid::Document
        include Mongoid::Timestamps

        store_in collection: 'tags'

        # @!attribute [rw] content
        #   @return [String] the string content of the tag, describing a characteristic.
        field :content, type: String
        # @!attribute [rw] count
        #   @return [Integer] the number of campaigns this tag is in, avoiding a join.
        field :count, type: Integer, default: 1

        validates :content, presence: { message: 'required' }, uniqueness: { message: 'uniq' }
      end
    end
  end
end