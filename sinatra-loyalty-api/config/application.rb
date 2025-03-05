require 'sinatra'
require 'sequel'
require 'json'
require 'i18n'

require_relative '../config/database'
require_relative '../routes/loyalty_routes'

I18n.load_path += Dir[File.expand_path('../config/locales/*.yml', __dir__)]
I18n.default_locale = :ru


Dir["#{File.dirname(__FILE__)}/../models/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/../services/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/../routes/*.rb"].each { |file| require file }
