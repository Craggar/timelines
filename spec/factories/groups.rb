FactoryBot.define do
  factory :group, class: Group do
    name { Faker::Name.name }
  end
end
