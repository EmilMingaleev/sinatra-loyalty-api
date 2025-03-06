# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OperationValidationService do
  let(:operation) do
    Operation.create(
      user_id: 1,
      check_summ: 1000.0,
      cashback: 50.0,
      cashback_percent: 5.0,
      discount: 100.0,
      discount_percent: 10.0,
      write_off: 0.0,
      done: false
    )
  end

  describe '.validate' do
    it 'возвращает операцию, если она существует и не выполнена' do
      result = OperationValidationService.validate(operation.id)
      expect(result).to eq(operation)
    end

    it 'возвращает ошибку, если операция не найдена' do
      result = OperationValidationService.validate(999)
      expect(result[:status]).to eq('error')
      expect(result[:message]).to eq(I18n.t('operation.not_found'))
    end

    it 'возвращает ошибку, если операция уже выполнена' do
      operation.update(done: true)
      result = OperationValidationService.validate(operation.id)
      expect(result[:status]).to eq('error')
      expect(result[:message]).to eq(I18n.t('operation.already_done'))
    end
  end
end
