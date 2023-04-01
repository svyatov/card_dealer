# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

desc "Run Steep typeckecker"
task :steep do
  exit(1) unless system("bundle exec steep check")
end

Dir["tasks/**/*.rake"].each { |t| load t }

task default: %i[steep rubocop spec]
