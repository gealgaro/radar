require "bundler/setup"
require "radar"
require 'webmock/rspec'
require 'vcr'
require 'pry'

Dir[File.expand_path('support/**/*.rb', File.dirname(__FILE__))].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  Radar.api_host = 'api.radar.io'
  Radar.secret_token = 'provide_your_test_secret_key'

  VCR.configure do |vcr_config|
    vcr_config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
    vcr_config.hook_into :webmock
    vcr_config.allow_http_connections_when_no_cassette = true
  end
end
