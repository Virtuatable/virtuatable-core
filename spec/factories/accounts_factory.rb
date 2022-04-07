FactoryBot.define do
  factory :empty_account, class: Core::Models::Account do
    factory :account do
      username { 'Babausse' }
      password { 'password' }
      firstname { 'Vincent' }
      lastname { 'Courtois' }
      email { 'courtois.vincent@outlook.com' }
      password_confirmation { 'password' }

      factory :conflicting_email_account do
        username { 'Alternate User' }
      end

      factory :conflicting_username_account do
        email { 'alternate@email.com' }
      end

      factory :account_with_groups do
        after :create do |account, evaluator|
          create_list(:group, 1, accounts: [account])
        end
      end

      factory :account_with_applications do
        after :create do |account, evaluator|
          create_list(:application, 1, creator: account)
        end
      end

      factory :account_with_authorizations do
        after :create do |account, evaluator|
          create_list(:authorization, 1, account: account, application: create(:application))
        end
      end

      factory :account_with_sessions do
        after :create do |account, evaluator|
          create_list(:session, 1, account: account)
        end
      end

      factory :account_with_websockets do
        after :create do |account, evaluator|
          create_list(:websocket, 1, creator: account)
        end
      end
    end
  end
end