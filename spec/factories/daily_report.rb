FactoryBot.define do
  factory :daily_report do
    association :owner, factory: :user
    association :receiver, factory: [:user, :manager]
    status { :pending }
    planned_tasks { "Complete project tasks" }
    actual_tasks { "Worked on project implementation" }
    incomplete_reason { "Waiting for client feedback" }
    next_day_planned_tasks { "Continue with implementation" }
    report_date { Date.current }
    manager_notes { nil }
    reviewed_at { nil }

    trait :read do
      status { :read }
      reviewed_at { Time.current }
      manager_notes { "Good work!" }
    end

    trait :commented do
      status { :commented }
      reviewed_at { Time.current }
      manager_notes { "Please provide more details" }
    end

    trait :without_receiver do
      receiver { nil }
    end
  end
end
