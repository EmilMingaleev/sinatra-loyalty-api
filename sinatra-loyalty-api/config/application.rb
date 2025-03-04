require 'sinatra'
require 'sequel'
require 'json'
require 'i18n'

require_relative '../config/database'
I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'locales', '*.yml')]
I18n.default_locale = :ru


Dir["#{File.dirname(__FILE__)}/../models/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/../services/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/../routes/*.rb"].each { |file| require file }
