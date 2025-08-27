FactoryBot.define do
  factory :department do
    sequence(:name) { |n| "Department #{n}" }
    description { "This is a default description for the department." }
    association :manager, factory: [:user, :manager]

    trait :without_manager do
      manager { nil }
    end
  end
end
