FactoryBot.define do
  factory :empty_token, class: Core::Models::Campaigns::Token do
    factory :token do
      name { 'Babausse' }
    end
  end

  factory :empty_position, class: Core::Models::Campaigns::TokenPosition do
    factory :position do
    end
  end
end