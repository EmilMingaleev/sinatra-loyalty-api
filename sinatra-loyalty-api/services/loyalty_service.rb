class LoyaltyService
  def self.calculate(user, positions, operation_id = nil)
    template = Template[user.template_id]
    total_discount = 0
    total_cashback = 0
    total_sum = 0
    total_available_write_off = 0
    discount_details = []

    positions.each do |pos|
      product = Product[pos[:id]]

      unless product
        discount_details << {
          id: pos[:id],
          price: pos[:price],
          quantity: pos[:quantity],
          type: nil,
          value: nil,
          type_desc: nil,
          discount_percent: 0.0,
          discount_summ: 0.0
        }
        next
      end

      product_calculation = ProductCalculator.calculate(product, pos, template)

      total_discount += product_calculation[:discount]
      total_cashback += product_calculation[:cashback]
      total_sum += product_calculation[:subtotal] - product_calculation[:discount]
      total_available_write_off += product_calculation[:subtotal] - product_calculation[:discount] unless product.type == 'noloyalty'

      discount_details << {
        id: pos[:id],
        price: pos[:price],
        quantity: pos[:quantity],
        type: product.type,
        value: product_calculation[:value],
        type_desc: product_calculation[:description],
        discount_percent: product_calculation[:discount_percent].round(2),
        discount_summ: product_calculation[:discount].round(2)
      }
    end

    if operation_id.nil?
      operation = Operation.create(
        user_id: user.id,
        check_summ: total_sum,
        cashback: 0.0,
        cashback_percent: 0.0,
        discount: 0.0,
        discount_percent: 0.0,
        done: false
      )
      operation_id = operation.id
    end
    

    discount_value = total_sum.zero? ? 0.0 : ((total_discount / total_sum) * 100).round(2)
    cashback_value = total_sum.zero? ? 0.0 : ((total_cashback / total_sum) * 100).round(2)

    LoyaltyResponseFormatter.format(user, operation_id, total_sum, total_available_write_off, total_cashback, total_discount, discount_details, template, discount_value, cashback_value)
  end
end
