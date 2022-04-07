FactoryGirl.define do
  factory :empty_campaign_tag, class: Core::Models::Campaigns::Tag do
    factory :campaign_tag do
      content 'content_tag'
    end
  end
end