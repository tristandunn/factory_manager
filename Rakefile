# frozen_string_literal: true

require "bundler/setup"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "yard"

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end

RuboCop::RakeTask.new do |task|
  task.options = %w(--parallel)
end

YARD::Rake::YardocTask.new do |t|
  t.files   = ["lib/**/*.rb"]
  t.options = ["--no-private"]
end

desc "Check the code"
task check: ["check:coverage"]

namespace :check do
  desc "Check the code, without coverage"
  task code: %i[spec rubocop]

  desc "Check the code, with coverage"
  task :coverage do
    ENV["COVERAGE"] = "true"

    Rake::Task["check:code"].invoke
  end
end

task default: [:spec]
