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
          product_id: pos[:id],
          discount: 0,
          cashback: 0,
          type: "unknown",
          description: "Product not found in the database",
          discount_percent: 0,
          cashback_percent: 0
        }
        next
      end

      product_calculation = ProductCalculator.calculate(product, pos, template)

      total_discount += product_calculation[:discount]
      total_cashback += product_calculation[:cashback]
      total_sum += product_calculation[:subtotal] - product_calculation[:discount]
      total_available_write_off += product_calculation[:subtotal] - product_calculation[:discount] unless product.type == 'noloyalty'

      discount_details << { 
        product_id: pos[:id],
        discount: product_calculation[:discount], 
        cashback: product_calculation[:cashback], 
        type: product.type,
        description: product_calculation[:description],
        discount_percent: product_calculation[:discount_percent],
        cashback_percent: product_calculation[:cashback_percent]
      }
    end

    LoyaltyResponseFormatter.format(user, operation_id, total_sum, total_available_write_off, total_cashback, total_discount, discount_details, template)
  end
end
