class ConfirmOperationService
  def self.confirm(user, operation_id, write_off)
    operation = OperationValidationService.validate(operation_id)
    return operation unless operation.is_a?(Operation)

    write_off_data = WriteOffCalculationService.calculate(operation, write_off)
    new_total = write_off_data[:new_total].round(2)
    new_cashback = write_off_data[:new_cashback].round(2)
    write_off = write_off_data[:write_off].round(2)

    OperationUpdateService.update(operation, write_off, new_total, new_cashback)

    {
      status: 200,
      message: "Данные успешно обработаны!",
      operation: {
        user_id: user.id,
        cashback: new_cashback,
        cashback_percent: operation.cashback_percent.to_f.round(2),
        discount: operation.discount.to_f.round(2).to_s,
        discount_percent: operation.discount_percent.to_f.round(2).to_s,
        write_off: write_off,
        check_summ: new_total
      }
    }
  end
end
