# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LoyaltyResponseFormatter do
  let(:user) { User.new(name: 'Иван', template_id: 1, bonus: 100.0).save }
  let(:template) { Template.new(name: 'Silver', discount: 10.0, cashback: 5.0).save }

  describe '.format' do
    it 'форматирует ответ с корректными данными' do
      response = LoyaltyResponseFormatter.format(
        user,
        1,
        1000.0,
        800.0,
        50.0,
        100.0,
        [],
        template,
        10.0,
        5.0
      )

      expect(response[:status]).to eq(200)
      expect(response[:user][:id]).to eq(user.id)
      expect(response[:summ]).to eq(1000.0)
      expect(response[:discount][:summ]).to eq(100.0)
      expect(response[:cashback][:will_add]).to eq(50.0)
    end
  end
end
