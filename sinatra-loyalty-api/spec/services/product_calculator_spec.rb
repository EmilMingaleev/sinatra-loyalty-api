# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ProductCalculator do
  let(:template) { Template.new(name: 'Silver', discount: 10.0, cashback: 5.0).save }
  let(:product) { Product.new(name: 'Молоко', type: 'increased_cashback', value: '10').save }

  describe '.calculate' do
    it 'возвращает корректный расчет для товара с повышенным кэшбеком' do
      pos = { price: 100, quantity: 2 }
      result = ProductCalculator.calculate(product, pos, template)

      expect(result[:subtotal]).to eq(200.0)
      expect(result[:discount]).to eq(0.0)
      expect(result[:cashback]).to eq(30.0)
      expect(result[:description]).to eq(I18n.t('product.cashback', value: '15.0%'))
    end
  end
end
