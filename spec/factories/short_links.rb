# frozen_string_literal: true

FactoryBot.define do
  factory :short_link, class: ShortLink do
    url { Faker::Internet.url }
    expires_on { 0 }
    click_count { 0 }
    uuid { SecureRandom.hex(3) }

    trait :with_custom_key do
      custom_key { Faker::Alphanumeric.alpha(number: 10) }
    end
  end
end
