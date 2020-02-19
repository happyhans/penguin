FactoryBot.define do
  factory :post do
    
  end

  factory :user do
    email { 'nan@penguin.com' }
    password { '123456' }

    trait :admin do
      admin { true }
    end

    factory :admin_user, traits: [:admin]
  end

  factory :random_user, class: 'User' do
    email { Faker::Internet.email }
    password { '123456' }

    trait :reset_pass_token do
      reset_password_token { 'ABCDEFG' }
      reset_password_token_expires { DateTime.now.utc + 10.hours }
    end

    trait :expired_reset_pass_token do
      reset_password_token { 'ABCDEFG' }
      reset_password_token_expires { DateTime.now.utc - 5.days }      
    end

    trait :admin do
      admin { true }
    end

    factory :random_admin_user, traits: [:admin]
    
    factory :random_user_with_reset_pass_token, traits: [:reset_pass_token]
    factory :random_user_with_expired_reset_pass_token, traits: [:expired_reset_pass_token]
  end

  factory :friend_request do
    association :sender, factory: :random_user
    association :receiver, factory: :random_user
  end

  factory :friendship do
    association :user, factory: :random_user
    association :friend, factory: :random_user
  end

  factory :refresh_token do
    token { SecureRandom.base58(16) }
    association :user, factory: :random_user
    expires { DateTime.now.utc + 7.days }
    
    trait :expired do
      expires { DateTime.now.utc - 1.hour }
    end

    factory :expired_refresh_token, traits: [:expired]
  end

  factory :conversation do
  end

  factory :message do
    body { Faker::Lorem.sentence }

    trait :blank do
      body { '' }
    end

    factory :blank_message, traits: [:blank]
  end
end


