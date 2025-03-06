# frozen_string_literal: true

require 'sinatra/base'
require 'json'
require_relative '../services/loyalty_service'
require_relative '../services/confirm_operation_service'

class LoyaltyAPI < Sinatra::Base
  set :port, 4567

  post '/operation' do
    content_type :json
    params = JSON.parse(request.body.read, symbolize_names: true)

    user = User[params[:user_id]]
    halt 404, { status: 'error', message: I18n.t('errors.user_not_found') }.to_json unless user

    positions = params[:positions]
    operation_id = params[:operation_id]

    result = LoyaltyService.calculate(user, positions, operation_id)
    result.to_json
  end

  post '/submit' do
    content_type :json
    params = JSON.parse(request.body.read, symbolize_names: true)

    user = User[params[:user][:id]]
    halt 404, { status: 'error', message: I18n.t('errors.user_not_found') }.to_json unless user

    operation_id = params[:operation_id]
    write_off = params[:write_off].to_f

    result = ConfirmOperationService.confirm(user, operation_id, write_off)
    result.to_json
  end
end
