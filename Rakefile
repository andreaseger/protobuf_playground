# frozen_string_literal: true
require 'bundler/setup'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'rebuild protobuf classes'
task :protobuf do
  `protoc --ruby_out=. lib/wire/*.proto`
end

task default: :spec
