FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'

    after(:build) { |user| user.class.skip_callback(:save, :after, :update_search_index) }
  end

  factory :student, parent: :user do
    role User::ROLES[:student]
  end

  factory :tutor, parent: :user do
    role User::ROLES[:tutor]
  end
end
