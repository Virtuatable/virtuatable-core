FactoryGirl.define do
  factory :empty_route, class: Core::Models::Permissions::Route do
    factory :route do
      path '/route'
      verb 'post'

      factory :premium_route do
        premium true
      end
      factory :inactive_route do
        active false
      end
    end
  end
end