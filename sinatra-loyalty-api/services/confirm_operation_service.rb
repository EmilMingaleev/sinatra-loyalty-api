# frozen_string_literal: true

class ConfirmOperationService
  def self.confirm(user, operation_id, write_off)
    operation = OperationValidationService.validate(operation_id)
    return operation unless operation.is_a?(Operation)

    check_summ = operation.check_summ.to_f
    cashback_percent = operation.cashback_percent.to_f
    discount = operation.discount.to_f

    available_write_off = [write_off.to_f, check_summ].min

    new_total = check_summ - available_write_off

    new_cashback = (new_total * cashback_percent / 100.0).round(2)

    OperationUpdateService.update(operation, available_write_off, new_total, new_cashback)

    {
      status: 200,
      message: I18n.t('confirm_operation.success'),
      operation: {
        user_id: user.id,
        cashback: new_cashback,
        cashback_percent: cashback_percent.round(2),
        discount: discount.round(2).to_s,
        discount_percent: (discount / check_summ * 100).round(2).to_s,
        write_off: available_write_off.round(2),
        check_summ: new_total.round(2)
      }
    }
  end
end
