# frozen_string_literal: true

class WriteOffCalculationService
  def self.calculate(operation, write_off)
    available_write_off = operation.allowed_write_off.to_f
    write_off = [write_off.to_f, available_write_off].min

    new_total = operation.check_summ.to_f - write_off
    cashback_percent = operation.cashback_percent.to_f
    new_cashback = ((new_total * cashback_percent) / 100.0).round(2)

    { new_total: new_total, new_cashback: new_cashback, write_off: write_off }
  end
end
