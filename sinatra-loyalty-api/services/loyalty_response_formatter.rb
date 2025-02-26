class LoyaltyResponseFormatter
  def self.format(user, operation_id, total_sum, total_available_write_off, total_cashback, total_discount, discount_details, template)
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
