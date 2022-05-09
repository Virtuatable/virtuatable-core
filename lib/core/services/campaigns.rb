module Core
  module Services
    class Campaigns
      include Singleton

      # Lists all the campaigns of a user identified by its account.
      #
      # @param account [Core::Models::Account] the user requesting its campaigns.
      # @param page [Integer] the page in the list of campaigns to return to the users.
      # @param per_page [Integer] the number of campaigns per page.
      #
      # @return [Array<Hash>] an array of hash representing campaigns.
      def list(account, page: 0, per_page: 20, **ignored)
        campaigns = campaigns(account).skip(page * per_page).limit(per_page)
        campaigns.map do |campaign|
          Core::Decorators::Campaign.new(campaign).to_simple_h
        end
      end

      def campaigns(account)
        invitations = account.invitations.where(enum_status: 'creator')
        Core::Models::Campaign.where(:id.in => invitations.map(&:campaign_id))
      end
    end
  end
end