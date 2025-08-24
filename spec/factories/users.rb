FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    role { :user }
    department { nil }

    trait :manager do
      role { :manager }
    end

    trait :admin do
      role { :admin }
    end

    trait :manager_with_department do
      role { :manager }
      association :department
    end

    trait :user_with_department do
      association :department
    end
  end
end
