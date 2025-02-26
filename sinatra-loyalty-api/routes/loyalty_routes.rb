require 'sinatra/base'
require 'json'
require_relative '../services/loyalty_service'
require_relative '../services/confirm_operation_service'

class LoyaltyAPI < Sinatra::Base
  set :port, 4567

  post '/calculate' do
    content_type :json
    data = JSON.parse(request.body.read, symbolize_names: true)
    user = User[data[:user_id]]
    halt 400, { status: "error", message: "User not found" }.to_json unless user
    positions = data[:positions]
    operation_id = data[:operation_id] || nil
    result = LoyaltyService.calculate(user, positions, operation_id)
    result.to_json
  end

  post '/confirm' do
    content_type :json
    data = JSON.parse(request.body.read, symbolize_names: true)
  
    user = User[data[:user][:id]]
    halt 400, { status: "error", message: "User not found" }.to_json unless user
  
    operation_id = data[:operation_id]
    write_off = data[:write_o].to_f
  
    result = ConfirmOperationService.confirm(user, operation_id, write_off)
  
    result.to_json
  end
end
