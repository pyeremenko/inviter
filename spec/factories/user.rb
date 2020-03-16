FactoryBot.define do
  factory :user do
    id { 1 }
    email { 'test@user.com' }
    name { 'john test' }
    password { 'qwerty' }
    credits { 0 }
  end
end
