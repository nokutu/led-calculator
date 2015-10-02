class Calculation < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true
  validates :post_code, presence: true

  has_many :calculation_lines

  ELECTRICITY_PRICE = 0.10

  def get_power_diff
    power_led = 0
    power_incandescent = 0
    calculation_lines.each do |calculation_line|
      power_led += calculation_line.product.power_led * calculation_line.amount
      power_incandescent += calculation_line.product.power_incandescent * calculation_line.amount
    end
    (power_incandescent - power_led).round(2)
  end

  def kw_saved_day
    spent_led = 0
    spent_incandescent = 0
    calculation_lines.each do |calculation_line|
      spent_led += calculation_line.product.power_led * calculation_line.amount * calculation_line.hours
      spent_incandescent += calculation_line.product.power_incandescent * calculation_line.amount * calculation_line.hours
    end
    ((spent_incandescent - spent_led) / 1000.0).round(2)
  end

  def get_cost
    cost = 0
    calculation_lines.each do |calculation_line|
      cost += calculation_line.product.price_led * calculation_line.amount
    end
    cost.round(2)
  end

  def get_amortization_time
    ((get_cost / (kw_saved_day * ELECTRICITY_PRICE))/30).to_int + 1
  end

  def get_monthly_save

    ((kw_saved_day * ELECTRICITY_PRICE) * 30).round(2)
  end

  def amortization_string
    ret = ""
    if get_amortization_time > 12
      ret += (get_amortization_time / 12).to_s + " years"
      if get_amortization_time.modulo(12) != 0
        ret += " and " + get_amortization_time.modulo(12).to_s + " months"
      end
    else
      ret += get_amortization_time.to_s + " months"
    end
    ret
  end

  def get_code
    #Use hashids
  end
end
