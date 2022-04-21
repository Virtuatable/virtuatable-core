module Core
  module Models
    module Concerns
      # Includes the slug field, always the same in all models.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      module Sluggable
        extend ActiveSupport::Concern

        included do
          # @!attribute [rw] slug
          #   @return [String] the slug of the current entity ; it must be snake-cased, longer than four characters, unique for the entity and given.
          field :slug, type: String

          validates :slug,
            length: {minimum: 4, message: 'minlength', if: :slug?},
            format: {with: /\A[a-z]+(_[a-z]+)*\z/, message: 'pattern', if: :slug?},
            uniqueness: {message: 'uniq', if: :slug?},
            presence: {message: 'required'}
        end
      end
    end
  end
end