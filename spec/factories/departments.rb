FactoryBot.define do
  factory :department do
    sequence(:name) { |n| "Department #{n}" }
    association :manager, factory: [:user, :manager]

    trait :without_manager do
      manager { nil }
    end
  end
end
