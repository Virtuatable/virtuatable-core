FactoryBot.define do
  factory :empty_document, class: Core::Models::Files::Document do
    factory :file do
      name { Faker::Games::LeagueOfLegends.location }
      extension { 'png' }
      mime_type { 'image/png' }
    end
  end
end