module Core
  module Models
    # A set of rules is describing how a specific game system works (eg. Dungeons and Dragons 5th Edition, or Fate)
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Ruleset
      include Mongoid::Document
      include Mongoid::Timestamps

      store_in collection: 'rulesets'

      # @!attribute [rw] name
      #   @return [String] the name of the ruleset (eq. "Dungeons and Dragons 4th Edition")
      field :name, type: String
      # @!attribute [rw] description
      #   @return [String] the complete description of the rule set to quickly have informations on its content.
      field :description, type: String
      # @!attribute [rw] mime_types
      #   @return [Array<String>] a list of MIME types accepted as character sheets MIME types.
      field :mime_types, type: Array, default: []

      # @!attribute [rw] creator
      #   @return [Core::Models::Account] the account of the user creating this ruleset.
      belongs_to :creator, class_name: 'Core::Models::Account', inverse_of: :rulesets
      # @!attribute [rw] campaigns
      #   @return [Array<Core::Models::Campaign>] the campaigns using this set of rules.
      has_many :campaigns, class_name: 'Core::Models::Campaign', inverse_of: :ruleset

      validates :name,
        presence: {message: 'required'},
        length: {minimum: 4, message: 'minlength', if: :name?},
        uniqueness: {message: 'uniq', if: :name?}
    end
  end
end