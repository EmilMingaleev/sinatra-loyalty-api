# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OperationUpdateService do
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

  describe '.update' do
    it 'обновляет операцию с новыми данными' do
      OperationUpdateService.update(operation, 150.0, 850.0, 42.5)

      updated_operation = Operation[operation.id]
      expect(updated_operation.write_off).to eq(150.0)
      expect(updated_operation.check_summ).to eq(850.0)
      expect(updated_operation.cashback).to eq(42.5)
      expect(updated_operation.done).to eq(true)
    end
  end
end
