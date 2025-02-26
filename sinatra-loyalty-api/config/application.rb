require 'sinatra'
require 'sequel'
require 'json'

require_relative '../config/database'

Dir["#{File.dirname(__FILE__)}/../models/*.rb"].each { |file| require file }

Dir["#{File.dirname(__FILE__)}/../services/*.rb"].each { |file| require file }

Dir["#{File.dirname(__FILE__)}/../routes/*.rb"].each { |file| require file }
