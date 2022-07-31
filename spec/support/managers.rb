# frozen_string_literal: true

RSpec.configure do |config|
  config.after do
    FactoryManager.managers.clear
  end
end
