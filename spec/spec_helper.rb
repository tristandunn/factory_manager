# frozen_string_literal: true

require "bundler/setup"

require "active_support/inflector"

if ENV["CI"] || ENV["COVERAGE"]
  require "simplecov"
  require "simplecov-console"

  SimpleCov.formatter = SimpleCov::Formatter::Console
  SimpleCov.start("rails") do
    coverage_dir "./tmp/cache/coverage"
    enable_coverage :branch
    minimum_coverage line: 100, branch: 100
  end
end

Bundler.require(:default, :development)

Dir[File.expand_path("support/**/*.rb", __dir__)].each do |file|
  require file
end

RSpec.configure do |config|
  config.expect_with :rspec do |rspec|
    rspec.syntax = :expect
  end

  # Raise errors for any deprecations.
  config.raise_errors_for_deprecations!
end
