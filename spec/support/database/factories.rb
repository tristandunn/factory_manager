# frozen_string_literal: true

require "factory_bot"

RSpec.configure do |config|
  config.before(:suite) do
    FactoryBot.define do
      factory :post do
        user

        sequence(:title) { |n| "Post ##{n}" }
      end

      factory :user do
        sequence(:name) { |n| "User ##{n}" }

        trait :admin do
          admin { true }
        end
      end
    end
  end
end
