# frozen_string_literal: true

require "factory_bot"

RSpec.configure do |config|
  config.before(:suite) do
    FactoryBot.define do
      factory :post do
        user
        uuid

        sequence(:title) { |n| "Post ##{n}" }
      end

      factory :user do
        sequence(:name) { |n| "User ##{n}" }

        trait :admin do
          admin { true }
        end

        factory :admin_user, aliases: [:super_admin] do
          sequence(:name) { |n| "Admin ##{n}" }

          admin { true }
        end
      end

      sequence :uuid do
        SecureRandom.uuid
      end
    end
  end
end
