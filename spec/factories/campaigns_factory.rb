FactoryBot.define do
  factory :empty_campaign, class: Core::Models::Campaign do
    factory :campaign do
      title { 'Test campaign' }
      description { 'Description of test campaign' }
    end
  end
end