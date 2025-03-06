# frozen_string_literal: true

require 'rspec'
require 'sequel'
require 'sinatra'
require 'i18n'
require_relative '../config/database'

I18n.load_path += Dir[File.expand_path('../config/locales/*.yml', __dir__)]
I18n.default_locale = :ru
I18n.enforce_available_locales = false

Dir[File.expand_path('../models/*.rb', __dir__)].sort.each { |file| require file }
Dir[File.expand_path('../services/*.rb', __dir__)].sort.each { |file| require file }

DB = Sequel.sqlite('test.db')

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
