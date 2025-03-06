# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LoyaltyService do
  let(:user) { User.new(name: 'Иван', template_id: 1, bonus: 100.0).save }
  let(:template) { Template.new(name: 'Silver', discount: 10.0, cashback: 5.0).save }
  let(:product1) { Product.new(name: 'Хлеб', type: nil, value: nil).save }
  let(:product2) { Product.new(name: 'Молоко', type: 'increased_cashback', value: '10').save }
  let(:product3) { Product.new(name: 'Сыр', type: 'discount', value: '15').save }
  let(:product4) { Product.new(name: 'Вода', type: 'noloyalty', value: nil).save }

  describe '.calculate' do
    it 'возвращает корректный расчет скидок и бонусов' do
      positions = [
        { id: 1, price: 100, quantity: 3 },
        { id: 2, price: 50, quantity: 2 },
        { id: 3, price: 40, quantity: 1 },
        { id: 4, price: 150, quantity: 2 }
      ]

      result = LoyaltyService.calculate(user, positions)

      expect(result[:status]).to eq(200)
      expect(result[:user][:id]).to eq(user.id)
      expect(result[:summ]).to eq(434.0)
      expect(result[:discount][:summ]).to eq(6.0)
      expect(result[:cashback][:will_add]).to eq(15.0)
    end
  end
end
