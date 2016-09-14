#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks

task :default => :spec

begin
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec) do |t|
    if ENV["CI"]
      raise "RAILS_VERSION must be specified on CI" unless ENV["RAILS_VERSION"]
    else
      ENV['RAILS_VERSION'] ||= "5.0"
    end
    puts "Testing with Rails #{ENV['RAILS_VERSION']}..." # See Gemfile
  end

  namespace :spec do
    RSpec::Core::RakeTask.new(:docs) do |t|
      t.rspec_opts = ["--format doc"]
    end
  end
rescue LoadError
end

