class ConfirmOperationService
  def self.confirm(user, operation_id, write_off)
    operation = OperationValidationService.validate(operation_id)
    return operation unless operation.is_a?(Operation)

    write_off_data = WriteOffCalculationService.calculate(operation, write_off)
    new_total = write_off_data[:new_total]
    new_cashback = write_off_data[:new_cashback]
    write_off = write_off_data[:write_off]

    OperationUpdateService.update(operation, write_off, new_total, new_cashback)

    {
      status: "success",
      message: "Operation confirmed",
      operation: {
        user_id: user.id,
        cashback: new_cashback,
        cashback_earned: new_cashback,
        cashback_percent: operation.cashback_percent.to_f,
        total_discount: operation.discount.to_f,
        discount_percent: operation.discount_percent.to_f,
        written_off: write_off,
        total_sum: new_total
      }
    }
  end
end
