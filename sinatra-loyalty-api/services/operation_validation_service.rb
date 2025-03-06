# frozen_string_literal: true

class OperationValidationService
  def self.validate(operation_id)
    operation = Operation[operation_id]
    return { status: 'error', message: I18n.t('operation.not_found') } unless operation
    return { status: 'error', message: I18n.t('operation.already_done') } if operation.done

    operation
  end
end
