class ProductCalculator
  def self.calculate(product, pos, template)
    subtotal = pos[:price] * pos[:quantity]
    discount = 0
    cashback = 0
    discount_percent = 0
    cashback_percent = 0
    value = nil
    description = nil

    case product.type
    when 'discount'
      discount_percent = template.discount.to_f
      discount = (subtotal * discount_percent / 100.0).round(2)
      value = "#{discount_percent}%"
      description = "Дополнительная скидка #{value}"
    when 'increased_cashback'
      cashback_percent = template.cashback.to_f
      cashback = (subtotal * cashback_percent / 100.0).round(2)
      value = "#{cashback_percent}%"
      description = "Дополнительный кэшбек #{value}"
    when 'noloyalty'
      description = "Не участвует в системе лояльности"
    end

    {
      subtotal: subtotal,
      discount: discount,
      cashback: cashback,
      discount_percent: discount_percent,
      cashback_percent: cashback_percent,
      value: value,
      description: description
    }
  end
end
