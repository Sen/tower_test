require 'ffaker'

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
  end

  factory :team do
    name { Faker::Name.name }
  end

  factory :project do
    name { Faker::Name.name }
    user
  end

  factory :todo do
    body "todo body"
    user
    project
    # association :assignee, factory: :user
  end
end
