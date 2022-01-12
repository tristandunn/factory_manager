# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Schema.define do
      self.verbose = false

      create_table :users, force: true do |t|
        t.string :name, null: false
        t.boolean :admin, null: false, default: false

        t.timestamps null: false
      end

      create_table :posts, force: true do |t|
        t.references :user, null: false
        t.string :uuid, null: false
        t.string :title, null: false

        t.timestamps null: false
      end
    end
  end
end
