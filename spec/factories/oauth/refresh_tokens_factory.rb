FactoryBot.define do
  factory :empty_refresh_token, class: Core::Models::OAuth::RefreshToken do
    factory :refresh_token do
      value { 'test_refresh_token' }
    end
  end
end