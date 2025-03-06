require 'spec_helper'

RSpec.describe ConfirmOperationService do

  before(:all) do
    I18n.locale = :ru
  end
  
  let(:user) { User.new(name: 'Иван', template_id: 1, bonus: 100.0).save }
  let(:template) { Template.new(name: 'Silver', discount: 10.0, cashback: 5.0).save }
  let(:operation) do
    Operation.create(
      user_id: user.id,
      check_summ: 1000.0,
      cashback: 50.0,
      cashback_percent: 5.0,
      discount: 100.0,
      discount_percent: 10.0,
      write_off: 0.0,
      done: false
    )
  end

  describe '.confirm' do
    it 'подтверждает операцию и возвращает корректные данные' do
      result = ConfirmOperationService.confirm(user, operation.id, 150.0)

      expect(result[:status]).to eq(200)
      expect(result[:message]).to eq(I18n.t('confirm_operation.success'))
      expect(result[:operation][:user_id]).to eq(user.id)
      expect(result[:operation][:cashback]).to eq(42.5)
      expect(result[:operation][:write_off]).to eq(150.0)
      expect(result[:operation][:check_summ]).to eq(850.0)
    end

    it 'возвращает ошибку, если операция не найдена' do
      result = ConfirmOperationService.confirm(user, 999, 150.0)

      expect(result[:status]).to eq("error")
      expect(result[:message]).to eq(I18n.t('operation.not_found'))
    end

    it 'возвращает ошибку, если операция уже выполнена' do
      operation.update(done: true)
      result = ConfirmOperationService.confirm(user, operation.id, 150.0)

      expect(result[:status]).to eq("error")
      expect(result[:message]).to eq(I18n.t('operation.already_done'))
    end
  end
end
