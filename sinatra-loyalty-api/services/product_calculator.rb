# frozen_string_literal: true

class ProductCalculator
  def self.calculate(product, pos, template)
    subtotal = pos[:price] * pos[:quantity]
    discount = 0
    cashback = 0
    discount_percent = 0
    cashback_percent = 0
    value = nil
    description = nil

    case template.name
    when 'Bronze'
      cashback_percent = template.cashback.to_f
    when 'Silver'
      discount_percent = template.discount.to_f
      cashback_percent = template.cashback.to_f
    when 'Gold'
      discount_percent = template.discount.to_f
    end

    if product
      case product.type
      when 'discount'
        discount_percent += product[:value].to_f
        discount = (subtotal * discount_percent / 100.0).round(2)
        value = "#{discount_percent}%"
        description = I18n.t('product.discount', value: value)
      when 'increased_cashback'
        cashback_percent += product[:value].to_f
        cashback = (subtotal * cashback_percent / 100.0).round(2)
        value = "#{cashback_percent}%"
        description = I18n.t('product.cashback', value: value)
      when 'noloyalty'
        description = I18n.t('product.noloyalty')
      else
        discount = (subtotal * discount_percent / 100.0).round(2)
        cashback = (subtotal * cashback_percent / 100.0).round(2)
        value = "#{discount_percent}%"
        description = I18n.t('product.standard')
      end
    else
      discount = (subtotal * discount_percent / 100.0).round(2)
      cashback = (subtotal * cashback_percent / 100.0).round(2)
      value = "#{discount_percent}%"
      description = I18n.t('product.standard')
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
