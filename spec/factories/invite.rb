FactoryBot.define do
  factory :invite do
    id { 1 }
    usages { 0 }
    code { 'cOd3' }
    user { create :user }
    bonus_applied { false }
  end
end
