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

      subtotal = pos[:price] * pos[:quantity]
      discount = 0
      cashback = 0
      discount_percent = 0
      cashback_percent = 0
      description = ''

      case product.type
      when 'discount'
        discount = (subtotal * template.discount.to_f / 100.0).round(2)
        discount_percent = template.discount.to_f
        description = 'Additional discount'
      when 'increased_cashback'
        cashback = (subtotal * template.cashback.to_f / 100.0).round(2)
        cashback_percent = template.cashback.to_f
        description = 'Additional cashback'
      when 'noloyalty'
        description = 'Product is not part of the loyalty program'
      end

      total_discount += discount
      total_cashback += cashback
      total_sum += subtotal - discount
      total_available_write_off += subtotal - discount unless product.type == 'noloyalty'

      discount_details << { 
        product_id: pos[:id],
        discount: discount, 
        cashback: cashback, 
        type: product.type,
        description: description,
        discount_percent: discount_percent,
        cashback_percent: cashback_percent
      }
    end

    {
      status: "success",
      user: {
        id: user.id,
        bonus_balance: user.bonus.to_f
      },
      operation_id: operation_id,
      total_sum: total_sum,
      written_off: 0,
      available_to_write_off: total_available_write_off.round(2),
      bonuses: {
        total_cashback: total_cashback,
        cashback_percent: template.cashback.to_f
      },
      discounts: {
        total_discount: total_discount,
        discount_percent: template.discount.to_f
      },
      positions: discount_details
    }
  end
end
