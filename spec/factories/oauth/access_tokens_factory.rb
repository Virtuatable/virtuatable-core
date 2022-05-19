FactoryBot.define do
  factory :empty_access_token, class: Core::Models::OAuth::AccessToken do
    factory :random_access_token do
      association :authorization, factory: :authorization, strategy: :build

      factory :access_token do
        value { 'test_access_token' }
      end
    end
  end
end