module Core
  module Models
    # A campaign is a gathering of accounts playing on the same interface, and interacting in a common game.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Campaign
      include Mongoid::Document
      include Mongoid::Timestamps

      store_in collection: 'campaigns'

      # @!attribute [rw] title
      #   @return [String] the title, or name, of the campaign, used to identify it in the list.
      field :title, type: String
      # @!attribute [rw] description
      #   @return [String] a more detailed description, used to give further information about the campaign in general.
      field :description, type: String
      # @!attribute [rw] is_private
      #   @return [Boolean] TRUE if the campaign can be joined only by being invited by the creator, FALSE if it's publicly displayed and accessible.
      field :is_private, type: Mongoid::Boolean, default: true
      # @!attribute [rw] tags
      #   @return [Array<String>] an array of tags describing characteristics of this campaign.
      field :tags, type: Array, default: []
      # @!attributes [rw] max_players
      #   @return [Integer] the maximum number of players allowed in this campaign.
      field :max_players, type: Integer, default: 5

      # @!attribute [rw] invitations
      #   @return [Array<Core::Models::Campaigns::Invitation>] the invitations to players that have been made for this campaign.
      has_many :invitations, class_name: 'Core::Models::Campaigns::Invitation', inverse_of: :campaign
      # @!attribute [rw] files
      #   @return [Array<Core::Models::Files::Document>] the files uploaded in this campaign.
      has_many :files, class_name: 'Core::Models::Files::Document'

      # @!attribute [rw] chatroom
      #   @return [Core::Models::Chatrooms::Campaign] the chatroom linked to this campaign.
      embeds_one :chatroom, class_name: 'Core::Models::Chatrooms::Campaign', inverse_of: :campaign

      # @!attribute [rw] tokens
      #   @return [Array<Core::Models::Campaigns::Token>] the tokens declared in this campaign.
      embeds_many :tokens, class_name: 'Core::Models::Campaigns::Token', inverse_of: :campaign

      # @!attribute [rw] ruleset
      #   @return [Core::Models::Ruleset] the set of rules this campaign is based upon.
      belongs_to :ruleset, class_name: 'Core::Models::Ruleset', inverse_of: :campaigns, optional: true

      validates :title,
        presence: {message: 'required'},
        length: {minimum: 4, message: 'minlength', if: :title?}

      validates :max_players,
        numericality: {less_than: 21, message: 'maximum'}

      validate :title_unicity

      validate :max_players_minimum

      # Sets the creator of the campaign. This method is mainly used for backward-compatibility needs.
      # @param account [Core::Models::Account] the account of the creator for this campaign.
      def creator=(account)
        if !invitations.where(account: account).exists?
          invitation = Core::Models::Campaigns::Invitation.create(
            campaign: self,
            account: account,
            status: :creator
          )
        end
      end

      # Getter for the creator account of this campaign.
      # @return [Core::Models::Account] the account of the player creating this campaign.
      def creator
        invitations.to_a.find(&:status_creator?).account
      end

      # Adds an error message if the account creating this campaign already has a campaign with the very same name.
      def title_unicity
        # First we take all the other campaign ids of the user.
        campaign_ids = creator.invitations.where(:campaign_id.ne => _id).pluck(:campaign_id)
        # With this list of campaign IDs, we look for a campaign with the same title.
        same_title_campaign = Core::Models::Campaign.where(:_id.in => campaign_ids, title: title)
        if !creator.nil? && title? && same_title_campaign.exists?
          errors.add(:title, 'uniq')
        end
      end

      # Validation for the max number of players for a campaign.
      # If there is a max number of players, and the current number of
      # players is above it, or the max number of players is 0, raises an error.
      def max_players_minimum
        if max_players? && (max_players < players_count || max_players < 1)
          errors.add(:max_players, 'minimum')
        end
      end

      # @return [Array<Core::Models::Campaigns::Invitation>] the players in this campaign.
      def players
        invitations.to_a.select do |invitation|
          [:creator, :accepted].include? invitation.enum_status
        end
      end

      # @return [Integer] the number of players in this campaign.
      def players_count
        players.count
      end

      def messages
        chatroom.messages
      end

      after_initialize do
        self.chatroom = Core::Models::Chatrooms::Campaign.new(campaign: self)
      end
    end
  end
end