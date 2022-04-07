FactoryGirl.define do
  factory :empty_event, class: Core::Models::Event do
    factory :status_event do
      field 'status'
    end
  end
end