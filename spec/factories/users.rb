FactoryBot.define do
  factory :user do
    password = Faker::Internet.password(min_length: 8)
    name {Faker::Name.last_name}
    email {Faker::Internet.free_email}
    password {12345678}
    password_confirmation {12345678}
  end
end