# frozen_string_literal: true

# rubocop:disable Lint/ConstantDefinitionInBlock
RSpec.configure do |config|
  config.before(:suite) do
    # The base ActiveRecord class.
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end

    # A post record.
    class Post < ApplicationRecord
      belongs_to :user, required: true

      validates :uuid, presence: true
      validates :title, presence: true
    end

    # A user record.
    class User < ApplicationRecord
      has_many :posts

      validates :name, presence: true
    end
  end
end
# rubocop:enable Lint/ConstantDefinitionInBlock
