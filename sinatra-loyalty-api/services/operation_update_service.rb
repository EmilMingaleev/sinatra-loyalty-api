class OperationUpdateService
  def self.update(operation, write_off, new_total, new_cashback)
    operation.update(
      write_off: write_off,
      check_summ: new_total,
      cashback: new_cashback,
      done: true
    )
  end
end
