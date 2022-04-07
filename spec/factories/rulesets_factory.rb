FactoryGirl.define do
  factory :empty_ruleset, class: Core::Models::Ruleset do
    factory :ruleset do
      name 'test ruleset'
      description 'description'
    end
  end
end