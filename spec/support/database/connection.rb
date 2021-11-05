# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
  end

  config.after do
    ApplicationRecord.subclasses.each(&:delete_all)
  end
end
