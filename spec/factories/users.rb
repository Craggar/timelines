FactoryBot.define do
  factory :user, class: User do
    name { Faker::Name.name }
  end

  factory :user_with_events, parent: :user do
    transient do
      events_count { 3 }
    end

    after(:create) do |user, evaluator|
      create_list(:event, evaluator.events_count, resource: user)
    end
  end
end
