FactoryBot.define do
  factory :empty_scope, class: Core::Models::OAuth::Scope do
    factory :scope do
      name { 'test-scope' }
    end
  end
end