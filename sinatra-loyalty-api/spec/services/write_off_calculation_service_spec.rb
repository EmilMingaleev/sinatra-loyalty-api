# frozen_string_literal: true

require 'spec_helper'

RSpec.describe WriteOffCalculationService do
  let(:operation) do
    Operation.create(
      user_id: 1,
      check_summ: 1000.0,
      cashback: 50.0,
      cashback_percent: 5.0,
      discount: 100.0,
      discount_percent: 10.0,
      write_off: 0.0,
      allowed_write_off: 200.0,
      done: false
    )
  end

  describe '.calculate' do
    it 'возвращает корректные данные для списания' do
      result = WriteOffCalculationService.calculate(operation, 150.0)

      expect(result[:new_total]).to eq(850.0)
      expect(result[:new_cashback]).to eq(42.5)
      expect(result[:write_off]).to eq(150.0)
    end
  end
end
