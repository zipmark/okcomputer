source "http://rubygems.org"

case ENV['RAILS_VERSION'];
when /3.2/
  gem "rails", "~> 3.2.0"
  gem 'test-unit', '~> 3.0' if RUBY_VERSION >= "2.2"
when /4.1/
  gem "rails", "~> 4.1.0"
when /4.2/
  gem "rails", "~> 4.2.0"
when /5.0/
  gem "rails", "~> 5.0.0"
end

gemspec
