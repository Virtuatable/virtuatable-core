FactoryGirl.define do
  factory :empty_session, class: Core::Models::Authentication::Session do
    factory :session do
      token 'session_token'
      association :account, factory: :account, strategy: :build
    end
  end
end