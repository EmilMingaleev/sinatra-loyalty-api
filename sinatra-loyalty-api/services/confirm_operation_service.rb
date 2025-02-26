class ConfirmOperationService
  def self.confirm(user, operation_id, write_off)
    operation = Operation[operation_id]
    return { status: "error", message: "Operation not found" } unless operation
    return { status: "error", message: "Operation already confirmed" } if operation.done

    available_write_off = operation.allowed_write_off.to_f
    write_off = [write_off.to_f, available_write_off].min

    new_total = operation.check_summ.to_f - write_off

    cashback_percent = operation.cashback_percent.to_f
    new_cashback = ((new_total * cashback_percent) / 100.0).round(2)

    operation.update(
      write_off: write_off,
      check_summ: new_total,
      cashback: new_cashback,
      done: true
    )

    {
      status: "success",
      message: "Operation confirmed",
      operation: {
        operation_id: operation.id,
        user_id: user.id,
        cashback: new_cashback,
        cashback_earned: new_cashback,
        cashback_percent: cashback_percent,
        total_discount: operation.discount.to_f,
        discount_percent: operation.discount_percent.to_f,
        written_off: write_off,
        total_sum: new_total
      }
    }
  end
end
