require "simplecov"

SimpleCov.start "rails" do
  add_filter "spec/"
  add_filter ".github/"
  add_filter "lib/generators/timelines/"
  add_filter "lib/timelines/version"

  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::SimpleFormatter,
    SimpleCov::Formatter::HTMLFormatter
  ])
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }
ENV["RAILS_ENV"] = "test"
require_relative "../spec/dummy/config/environment"
ENV["RAILS_ROOT"] ||= "#{File.dirname(__FILE__)}../../../spec/dummy"

require "factory_bot_rails"
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
FactoryBot.definition_file_paths << File.join(File.dirname(__FILE__), "factories")
FactoryBot.find_definitions

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
