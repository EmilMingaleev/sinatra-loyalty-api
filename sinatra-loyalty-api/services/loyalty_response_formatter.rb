# frozen_string_literal: true

class LoyaltyResponseFormatter
  def self.format(user, operation_id, total_sum, total_available_write_off, total_cashback, total_discount, discount_details, _template, discount_value, cashback_value)
    {
      status: 200,
      user: {
        id: user.id,
        template_id: user.template_id,
        name: user.name,
        bonus: user.bonus.to_f.round(2)
      },
      operation_id: operation_id,
      summ: total_sum.round(2),
      positions: discount_details,
      discount: {
        summ: total_discount.round(2),
        value: "#{discount_value}%"
      },
      cashback: {
        existed_summ: user.bonus.to_f.round(2),
        allowed_summ: total_available_write_off.round(2),
        value: "#{cashback_value}%",
        will_add: total_cashback.round(2)
      }
    }
  end
end
