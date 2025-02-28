class OperationValidationService
    def self.validate(operation_id)
        operation = Operation[operation_id]
        return { status: "error", message: "Операция не найдена!" } unless operation
        return { status: "error", message: "Операция уже проведена!" } if operation.done
        operation
    end
end
