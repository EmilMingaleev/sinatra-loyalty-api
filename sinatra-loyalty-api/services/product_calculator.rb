class ProductCalculator
  def self.calculate(product, pos, template)
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

    { 
      subtotal: subtotal,
      discount: discount,
      cashback: cashback,
      discount_percent: discount_percent,
      cashback_percent: cashback_percent,
      description: description
    }
  end
end
