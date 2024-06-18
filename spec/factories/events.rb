FactoryBot.define do
  factory :event, class: ::Timelines::Event do
    association :resource, factory: :user
    association :actor, factory: :user
    event { :created }

    trait :created do
      event { :created }
    end

    trait :destroyed do
      event { :destroyed }
    end
  end
end
