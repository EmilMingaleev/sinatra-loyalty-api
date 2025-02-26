class OperationValidationService
    def self.validate(operation_id)
        operation = Operation[operation_id]
        return { status: "error", message: "Operation not found" } unless operation
        return { status: "error", message: "Operation already confirmed" } if operation.done
        operation
    end
end
